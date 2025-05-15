//
//  HomeScreenFactory.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit

protocol IHomeScreenFactory {
    func makeHomeScreen() -> BTFHomeScreenViewController
    func makeHomeView(viewModel: IBTFHomeViewModel) -> BTFHomeView
    func makeSearchButton(action: UIAction) -> BTFSearchButton
    func makeBTFResultsCollectionViewController(
        viewModel: IBTFHomeViewModel
    ) -> BTFResultsCollectionViewController
}

final class HomeScreenFactory: IHomeScreenFactory {
    
    func makeHomeScreen() -> BTFHomeScreenViewController {
        let useCase = FindBluetoothDevicesUseCase(service: BluetoothService())
        let viewModel = BTFHomeViewModel(useCase: useCase)
        return BTFHomeScreenViewController(viewModel: viewModel, viewFactory: self)
    }
    
    func makeHomeView(viewModel: IBTFHomeViewModel) -> BTFHomeView {
        return BTFHomeView(frame: .zero, viewModel: viewModel, factory: self)
    }
    
    func makeSearchButton(action: UIAction) -> BTFSearchButton {
        return BTFSearchButton(
            frame: .zero,
            titleLabel: Constatns.searchButtonTitle,
            action: action
        )
    }
    
    func makeBTFResultsCollectionViewController(
        viewModel: IBTFHomeViewModel
    ) -> BTFResultsCollectionViewController {
        BTFResultsCollectionViewController(viewModel: viewModel)
    }
}
