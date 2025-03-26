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
public struct SwipeToDeleteView<Content: View>: View {
    @State private var offset: CGFloat = 0
    @State private var isDeleteShowing: Bool = false
    @State private var size: CGSize = .zero
    @State private var id = UUID()
    private let threshold: CGFloat = 80

    private let content: () -> Content
    private let onDelete: () -> Void

    public init(
        content: @escaping () -> Content,
        onDelete: @escaping () -> Void
    ) {
        self.content = content
        self.onDelete = onDelete
    }

    public var body: some View {
        ZStack(alignment: .trailing) {
            Color.red
                .opacity(offset < 0 ? 1 : 0)
            Button(role: .destructive, action: {
                withAnimation {
                    offset = -size.width
                    onDelete()
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .frame(width: threshold, alignment: .center)
            }

            ChildSizeReader(size: $size) {
                content()
            }
            .background(Color.surface)
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
                        if value.translation.width < 0 && !isDeleteShowing {
                            offset = value.translation.width
                        } else if value.translation.width < threshold && isDeleteShowing {
                            offset = value.translation.width - threshold
                        } else if value.translation.width > 0 && isDeleteShowing {
                            offset = min(0, value.translation.width - threshold)
                        }
                        if swipeToDeleteViewActiveId.value != id {
                            swipeToDeleteViewActiveId.send(id)
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -size.width + threshold && !isDeleteShowing || value.translation.width < -size.width + threshold * 2 && isDeleteShowing {
                            withAnimation {
                                offset = -size.width
                                onDelete()
                            }
                        } else if value.translation.width < -threshold {
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
        }
    }
}
