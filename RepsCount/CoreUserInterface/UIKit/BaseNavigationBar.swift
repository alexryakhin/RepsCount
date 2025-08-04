//
//  BaseNavigationBar.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import UIKit

class BaseNavigationBar: UINavigationBar {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Methods to Implement
    
    open func setup() { }
}

final class NavigationBar: BaseNavigationBar {}
