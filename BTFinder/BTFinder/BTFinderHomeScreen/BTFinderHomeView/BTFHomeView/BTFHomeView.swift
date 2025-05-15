//
//  BTFHomeView.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit
import Combine

final class BTFHomeView: UIView {
    
    // MARK: - UI
    private let searchButton: BTFSearchButton
    private let btfResultsCollectionView: UICollectionViewController
    
    // MARK: - private properties
    private let viewModel: IBTFHomeViewModel
    private let factory: IHomeScreenFactory
    
    // MARK: - init
    init(
        frame: CGRect,
        viewModel: IBTFHomeViewModel,
        factory: IHomeScreenFactory
    ) {
        self.viewModel = viewModel
        self.factory = factory
        
        searchButton = factory.makeSearchButton(action: UIAction { _ in
            viewModel.findBTs()
        })
        btfResultsCollectionView = factory.makeBTFResultsCollectionViewController(viewModel: viewModel)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(searchButton)
        addSubview(btfResultsCollectionView.collectionView)
    }
    
    private func applyConstraints() {
        // searchButton constraints
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 150),
            searchButton.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // collectionView constraints
        if let collectionView = btfResultsCollectionView.collectionView {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
