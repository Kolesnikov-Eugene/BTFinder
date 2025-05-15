//
//  BTFResultsCollectionViewCell.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 14.05.2025.
//

import UIKit

final class BTFResultsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .textMain)
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var connectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
    
    // MARK: - private methods
    func configure(with device: BTFDevice) {
        deviceNameLabel.text = device.name
        connectionLabel.text = device.connectionStatus
    }
    
    // MARK: - private methods
    private func setupUI() {
        backgroundColor = Constatns.Colors.cellBackground
        layer.cornerRadius = 8
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(deviceNameLabel)
        contentView.addSubview(connectionLabel)
    }
    
    private func applyConstraints() {
        // device name label constraints
        NSLayoutConstraint.activate([
            deviceNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        // conection label constraints
        NSLayoutConstraint.activate([
            connectionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            connectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
