//
//  AppMainCoordinator.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol IAppMainCoordinator: Coordinator {}

final class AppMainCoordinator: IAppMainCoordinator {

    // MARK: - Properties
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    // MARK: - Public Methods
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startFlows()
    }

    // MARK: - Private Methods
    private func startFlows() {
        let homeScreenFactory = HomeScreenFactory()
        let btFinderFlow = BTFinderFlowCoordinator(
            navigationController: navigationController,
            homeScreenFactory: homeScreenFactory
        )

        childCoordinators.append(btFinderFlow)
        btFinderFlow.start()
    }

    private func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
