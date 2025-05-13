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
    private var mainButton: BTFMainButton!
    private var btfResultsCollectionView: UICollectionViewController!
    
    // MARK: - private properties
    private let viewModel: IBTFHomeViewModel
    
    // MARK: - init
    init(
        frame: CGRect,
        viewModel: IBTFHomeViewModel
    ) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        // TODO: - extract to factory
        mainButton = BTFMainButton(frame: .zero)
        btfResultsCollectionView = BTFResultsCollectionViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    private func setupView() {
        backgroundColor = .blue
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        
    }
    
    private func applyConstraints() {
        
    }
}
