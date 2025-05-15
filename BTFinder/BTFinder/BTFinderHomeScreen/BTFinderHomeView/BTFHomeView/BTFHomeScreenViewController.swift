//
//  HomeScreenViewController.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit

final class BTFHomeScreenViewController: UIViewController {
    
    // MARK: - private properties
    private let viewModel: IBTFHomeViewModel
    private let homeViewFactory: IHomeScreenFactory
    
    // MARK: - init
    init(
        viewModel: IBTFHomeViewModel,
        viewFactory: IHomeScreenFactory
    ) {
        self.viewModel = viewModel
        self.homeViewFactory = viewFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = homeViewFactory.makeHomeView(viewModel: viewModel)
    }
}
