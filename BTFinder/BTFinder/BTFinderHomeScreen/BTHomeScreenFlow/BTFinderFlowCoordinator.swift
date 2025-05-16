//
//  BTFinderFlow.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit

final class BTFinderFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    private let homeScreenFactory: IHomeScreenFactory
    
    // MARK: - Init
    init(
        navigationController: UINavigationController,
        homeScreenFactory: IHomeScreenFactory
    ) {
        self.navigationController = navigationController
        self.homeScreenFactory = homeScreenFactory
    }
    
    // MARK: - Public Methods
    func start() {
        let vc = homeScreenFactory.makeHomeScreen()
        navigationController.pushViewController(vc, animated: false)
    }
}
