//
//  SeparatorView.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 08.05.2021.
//  Copyright © 2021 Anton Poltoratskyi. All rights reserved.
//

import UIKit

final class SeparatorView: UIView {
    
    enum Axis {
        case vertical
        case horizontal
    }
    
    var axis: Axis = .horizontal {
        didSet {
            updateAxis()
        }
    }
    
    // MARK: - Subviews
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let lightThemeColor = UIColor.lightGray
        let darkThemeColor = UIColor.darkGray
        
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    return lightThemeColor
                case .dark:
                    return darkThemeColor
                @unknown default:
                    return lightThemeColor
                }
            }
        } else {
            contentView.backgroundColor = lightThemeColor
        }
        
        addSubview(contentView)
        
        return contentView
    }()
    
    private lazy var heightConstraint = heightAnchor.constraint(equalToConstant: separatorThickness(for: traitCollection))
    private lazy var widthConstraint = widthAnchor.constraint(equalToConstant: separatorThickness(for: traitCollection))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Base Setup
    
    private func initialize() {
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateAxis()
    }
    
    private func updateAxis() {
        switch axis {
        case .horizontal:
            widthConstraint.isActive = false
            heightConstraint.isActive = true
        case .vertical:
            widthConstraint.isActive = true
            heightConstraint.isActive = false
        }
    }
    
    private func separatorThickness(for traitCollection: UITraitCollection?) -> CGFloat {
        return 1.0 / max(1, traitCollection?.displayScale ?? 1)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        heightConstraint.constant = separatorThickness(for: traitCollection)
        widthConstraint.constant = separatorThickness(for: traitCollection)
    }
}
