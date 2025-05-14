//
//  BTFResultsCollectionViewCell.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 14.05.2025.
//

import UIKit

final class BTFResultsCollectionViewCell: UICollectionViewCell {
    
    private lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .textMain)
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with device: BTFDevice) {
        deviceNameLabel.text = device.name
    }
    
    private func setupUI() {
        backgroundColor = .red
        layer.cornerRadius = 8
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(deviceNameLabel)
    }
    
    private func applyConstraints() {
        // device name label constraints
        NSLayoutConstraint.activate([
            deviceNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
}
