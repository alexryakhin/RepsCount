//
//  ConfigurableView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

public protocol ConfigurableView: View {
    associatedtype Model

    var model: Model { get }
}
