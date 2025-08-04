//
//  SwipeToDeleteView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/26/25.
//

import Combine
import SwiftUI

private var swipeToDeleteViewActiveId: CurrentValueSubject<UUID?, Never> = .init(nil)

/**
Use this view if you need a swipe to delete gesture in a custom row (not using `List`)
Apply `.id()` modifier on to SwipeToDeleteView inside LazyVStack to avoid bugs with reusing cells
*/
struct SwipeToDeleteView<Content: View>: View {

    @Environment(\.layoutDirection) var layoutDirection

    @State private var offset: CGFloat = 0
    @State private var isDeleteShowing: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var size: CGSize = .zero
    @State private var id = UUID()
    private let threshold: CGFloat = 80

    private let content: () -> Content
    private let onDelete: () -> Void

    init(
        content: @escaping () -> Content,
        onDelete: @escaping () -> Void
    ) {
        self.content = content
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Color.red
                .opacity(offset < 0 ? 1 : 0)
            Button(role: .destructive, action: {
                withAnimation {
                    delete()
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .frame(width: threshold, alignment: .center)
            }

            ChildSizeReader(size: $size) {
                content()
            }
            .background(Color(.secondarySystemGroupedBackground))
            .offset(x: offset)
            .onReceive(swipeToDeleteViewActiveId, perform: { newID in
                if newID != id && isDeleteShowing {
                    withAnimation {
                        offset = 0
                        isDeleteShowing = false
                    }
                }
            })
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        let translation = layoutDirection == .rightToLeft ? -value.translation.width : value.translation.width
                        if translation < 0 && !isDeleteShowing {
                            offset = translation
                        } else if translation < threshold && isDeleteShowing {
                            offset = translation - threshold
                        } else if translation > 0 && isDeleteShowing {
                            offset = min(0, translation - threshold)
                        }
                        if swipeToDeleteViewActiveId.value != id {
                            swipeToDeleteViewActiveId.send(id)
                        }
                    }
                    .onEnded { value in
                        let translation = layoutDirection == .rightToLeft ? -value.translation.width : value.translation.width
                        if translation < -size.width + threshold && !isDeleteShowing || translation < -size.width + threshold * 2 && isDeleteShowing {
                            withAnimation {
                                delete()
                            }
                        } else if translation < -threshold {
                            withAnimation {
                                offset = -threshold
                                isDeleteShowing = true
                            }
                        } else {
                            withAnimation {
                                offset = 0
                                isDeleteShowing = false
                            }
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    withAnimation {
                        offset = 0
                        isDeleteShowing = false
                    }
                }
            )
        }
        .onDisappear {
            withAnimation {
                offset = 0
                isDeleteShowing = false
            }
        }
    }

    private func delete() {
        onDelete()
        offset = 0
        isDeleteShowing = false
    }
}
