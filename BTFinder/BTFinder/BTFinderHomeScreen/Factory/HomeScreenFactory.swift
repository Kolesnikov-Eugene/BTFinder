//
//  HomeScreenFactory.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import Foundation

protocol IHomeScreenFactory {
    func makeHomeScreen() -> BTFHomeScreenViewController
}

final class HomeScreenFactory: IHomeScreenFactory {
    
    func makeHomeScreen() -> BTFHomeScreenViewController {
        let useCase = FindBluetoothDevicesUseCase(service: BluetoothService())
        let viewModel = BTFHomeViewModel(useCase: useCase)
        return BTFHomeScreenViewController(viewModel: viewModel)
    }
}
