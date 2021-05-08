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
    
    // MARK: - Subviews
    
    // MARK: Blur
    
    private lazy var blurView: UIVisualEffectView = {
        let blurStyle: UIBlurEffect.Style
        if #available(iOS 13, *) {
            blurStyle = .systemMaterial
        } else {
            blurStyle = .extraLight
        }
        let blurEffect = UIBlurEffect(style: blurStyle)
        
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(effectView)
        
        return effectView
    }()
    
    // MARK: Content
    
    private lazy var contentContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(containerView)
        return containerView
    }()
    
    private lazy var contentStackView: UIStackView = {
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
    
    // MARK: Actions
    
    private lazy var actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var contentSeparatorView: UIView = {
        let separatorView = SeparatorView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.axis = .horizontal
        return separatorView
    }()
    
    private lazy var actionSequenceView: AlertActionSequenceView = {
        let sequenceView = AlertActionSequenceView()
        sequenceView.translatesAutoresizingMaskIntoConstraints = false
        return sequenceView
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
            
            contentStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: Layout.Content.top),
            contentStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: Layout.Content.horizontal),
            contentStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -Layout.Content.horizontal),
            contentStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -Layout.Content.bottom),
            
            actionsStackView.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            actionsStackView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
            actionsStackView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor),
            actionsStackView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor)
        ])
        
        contentStackView.axis = .vertical
        contentStackView.spacing = Layout.Content.verticalSpacing
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(messageLabel)
        contentStackView.addArrangedSubview(customContentView)
        
        actionsStackView.axis = .vertical
        actionsStackView.spacing = 0
        actionsStackView.addArrangedSubview(contentSeparatorView)
        actionsStackView.addArrangedSubview(actionSequenceView)
        
        [titleLabel, messageLabel].forEach {
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        actionSequenceView.delegate = self
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
        
        switch viewModel.title {
        case let .string(text, font):
            titleLabel.text = text
            titleLabel.font = font
        case let .attributedString(attributedText):
            titleLabel.attributedText = attributedText
        case nil:
            titleLabel.text = nil
        }
        titleLabel.isHidden = viewModel.title == nil
        
        switch viewModel.message {
        case let .string(text, font):
            messageLabel.text = text
            messageLabel.font = font
        case let .attributedString(attributedText):
            messageLabel.attributedText = attributedText
        case nil:
            messageLabel.text = nil
        }
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
        
        if !viewModel.actions.isEmpty {
            let actionsViewModel = AlertActionSequenceViewModel(
                actions: viewModel.actions,
                disabledTintColor: viewModel.disabledTintColor
            )
            actionSequenceView.setup(viewModel: actionsViewModel)
        }
        contentSeparatorView.isHidden = viewModel.actions.isEmpty
        actionSequenceView.isHidden = viewModel.actions.isEmpty
    }
    
    // MARK: - Layout
    
    private enum Layout {
        
        enum Content {
            static let top: CGFloat = 20
            static let bottom: CGFloat = 20
            static let horizontal: CGFloat = 16
            static let verticalSpacing: CGFloat = 4
        }
    }
}

// MARK: - AlertActionSequenceViewDelegate

extension AlertView: AlertActionSequenceViewDelegate {
    
    func alertActionSequenceView(_ actionView: AlertActionSequenceView, tappedAtIndex index: Int) {
        delegate?.alertView(self, buttonTappedAtIndex: index)
    }
}
