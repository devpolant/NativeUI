//
//  AlertView.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: AnyObject {
    func alertView(_ alertView: AlertView, buttonTappedAtIndex index: Int)
}

final class AlertView: UIView {
    
    private var viewModel: Alert?
    
    weak var delegate: AlertViewDelegate?
    
    private let separatorColor: UIColor = UIColor.lightGray
    
    // MARK: - Subviews
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(effectView)
        
        return effectView
    }()
    
    private lazy var contentContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(containerView)
        return containerView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var customContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var contentSeparatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = separatorColor
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(separatorView)
        return separatorView
    }()
    
    private lazy var actionsContainerView: AlertActionSequenceView = {
        let containerView = AlertActionSequenceView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(containerView)
        return containerView
    }()
    
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
        setupLayout()
        setupAppearance()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentContainerView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: Layout.Content.top),
            verticalStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: Layout.Content.horizontal),
            verticalStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -Layout.Content.horizontal),
            verticalStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -Layout.Content.bottom),
            
            contentSeparatorView.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            contentSeparatorView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
            contentSeparatorView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor),
            contentSeparatorView.heightAnchor.constraint(equalToConstant: Layout.separatorThickness),
            
            actionsContainerView.topAnchor.constraint(equalTo: contentSeparatorView.bottomAnchor),
            actionsContainerView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
            actionsContainerView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor),
            actionsContainerView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor),
            actionsContainerView.heightAnchor.constraint(equalToConstant: Layout.Button.height)
        ])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Layout.Content.verticalSpacing
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(messageLabel)
        verticalStackView.addArrangedSubview(customContentView)
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageLabel.setContentHuggingPriority(.required, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        actionsContainerView.delegate = self
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
    }
    
    // MARK: - Setup
    
    func setup(viewModel: Alert) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        titleLabel.font = viewModel.titleFont
        titleLabel.isHidden = viewModel.title == nil
        
        messageLabel.text = viewModel.message
        messageLabel.font = viewModel.messageFont
        messageLabel.isHidden = viewModel.message == nil
        
        if let contentView = viewModel.contentView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            customContentView.addSubview(contentView)
            
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: customContentView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor)
            ])
        }
        customContentView.isHidden = viewModel.contentView == nil
        
        let actionsViewModel = AlertActionSequenceViewModel(
            actions: viewModel.actions,
            separatorColor: separatorColor,
            separatorWidth: Layout.separatorThickness
        )
        actionsContainerView.setup(viewModel: actionsViewModel)
    }
    
    // MARK: - Layout
    
    private enum Layout {
        
        static var separatorThickness: CGFloat {
            return 1.0 / UIScreen.main.scale
        }
        
        enum Content {
            static let top: CGFloat = 20
            static let bottom: CGFloat = 20
            static let horizontal: CGFloat = 16
            static let verticalSpacing: CGFloat = 4
        }
        
        enum Button {
            static let height: CGFloat = 44
        }
    }
}

// MARK: - AlertActionSequenceViewDelegate

extension AlertView: AlertActionSequenceViewDelegate {
    
    func alertActionSequenceView(_ actionView: AlertActionSequenceView, tappedAtIndex index: Int) {
        delegate?.alertView(self, buttonTappedAtIndex: index)
    }
}
