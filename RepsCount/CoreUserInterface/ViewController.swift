//
//  ViewController.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/11/25.
//

import UIKit
import SwiftUI

public final class ViewController: UIHostingController<ContentView> {

    public init() {
        super.init(rootView: ContentView())
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public struct ContentView: View {
    public var body: some View {
        Text("ContentView")
    }
}
