//
//  BTFResultsCollectionViewController.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit
import Combine

private let reuseIdentifier = "Cell"

enum BTFResultsSection: Hashable {
    case main
}

enum BTFResultsItem: Hashable, Equatable {
    case device(BTFDevice)
}

struct BTFDevice: Hashable {
    let id = UUID()
    let name: String
}

final class BTFResultsCollectionViewController: UICollectionViewController {
    
    // MARK: - pivate properties
    private let viewModel: IBTFHomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<BTFResultsSection, BTFResultsItem>!
    private var bag = Set<AnyCancellable>()
    
    // MARK: - init
    init(
        viewModel: IBTFHomeViewModel
    ) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: BTFResultsCollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView
            .register(BTFResultsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureCollectionView()
        configureDataSource()
        bindToViewModel()
    }
    
    // MARK: - layout
    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let columns = 1
            let cellWidth = 1.0
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(cellWidth),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 8, leading: 0, bottom: 0, trailing: 0)
            
            let groupHeight: NSCollectionLayoutDimension = .fractionalHeight(1 / 9)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: groupHeight
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: columns
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
            return section
        }
    }
    
    // MARK: - private methods
    private func bindToViewModel() {
        viewModel.devices
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateSnapshot()
                }
                .store(in: &bag)
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? BTFResultsCollectionViewCell else {
                    fatalError("Error creating news feed cell")
                }
                switch itemIdentifier {
                case .device(let deviceItem):
                    cell.configure(with: deviceItem)
                }
                return cell
            })
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<BTFResultsSection, BTFResultsItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.devicesList)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
    }
}
