//
//  BaseTabController.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import UIKit

class BaseTabController: UITabBarController {

    required init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    open func setup() {}
}

final class TabController: BaseTabController {
    // MARK: - Public Properties

    var controllers = [NavigationController]() {
        didSet {
            viewControllers = controllers
            selectedIndex = 0
        }
    }

    // MARK: - Public Methods

    func forceSwitchTab(to tabIndex: Int) {
        selectedIndex = tabIndex
    }
}
