//
//  BTFMainButton.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import UIKit

final class BTFSearchButton: UIButton {
    
    init(frame: CGRect, titleLabel: String, action: UIAction) {
        super.init(frame: frame)
        
        var customBtnConfiguration = UIButton.Configuration.filled()
        customBtnConfiguration.baseBackgroundColor = .systemBlue
        customBtnConfiguration.baseForegroundColor = UIColor(resource: .textMain)

        let attributedTitle = AttributedString(titleLabel, attributes: AttributeContainer([
            .foregroundColor: UIColor(resource: .textMain),
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]))
        customBtnConfiguration.attributedTitle = attributedTitle
        
        configuration = customBtnConfiguration
        addAction(action, for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        layer.masksToBounds = true
    }
}
