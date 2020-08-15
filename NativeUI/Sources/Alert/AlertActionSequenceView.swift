//
//  AlertActionSequenceViewModel.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol AlertActionSequenceViewDelegate: AnyObject {
    func alertActionSequenceView(_ actionView: AlertActionSequenceView, tappedAtIndex index: Int)
}

struct AlertActionSequenceViewModel {
    let actions: [Alert.Action]
    let disabledTintColor: UIColor?
    let separatorColor: UIColor
    let separatorWidth: CGFloat
}

final class AlertActionSequenceView: UIControl {
    
    weak var delegate: AlertActionSequenceViewDelegate?
    
    private let selectionFeedbackGenerator = SelectionFeedbackGenerator()
    
    // MARK: - Subviews
    
    private final class ActionView: UIView {
        
        var isHighlighted: Bool = false {
            didSet {
                backgroundColor = isHighlighted ? UIColor.lightGray.withAlphaComponent(0.2) : .clear
            }
        }
        
        var isEnabled: Bool = true
        
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initialize()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initialize()
        }
        
        private func initialize() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10)
            ])
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        return stackView
    }()
    
    private var highlightedView: UIView?
    
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
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Setup
    
    func setup(viewModel: AlertActionSequenceViewModel) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        if let action = viewModel.actions.first {
            let actionView = makeActionView(for: action, disabledTintColor: viewModel.disabledTintColor)
            stackView.addArrangedSubview(actionView)
        }
        
        for action in viewModel.actions.dropFirst() {
            let separator = makeButtonSeparatorView(viewModel: viewModel)
            stackView.addArrangedSubview(separator)
            
            let actionView = makeActionView(for: action, disabledTintColor: viewModel.disabledTintColor)
            stackView.addArrangedSubview(actionView)
            
            if let firstActionView = stackView.arrangedSubviews.first(where: { $0 !== actionView }) {
                actionView.widthAnchor.constraint(equalTo: firstActionView.widthAnchor).isActive = true
            }
        }
    }
    
    private func makeActionView(for action: Alert.Action, disabledTintColor: UIColor?) -> ActionView {
        let actionView = ActionView()
        actionView.translatesAutoresizingMaskIntoConstraints = false
        
        updateAppearance(for: actionView, action: action, disabledTintColor: disabledTintColor)
        
        action.actionStateHandler = { [weak actionView, weak action, weak self] isEnabled in
            guard let actionView = actionView, let action = action else { return }
            self?.updateAppearance(for: actionView, action: action, disabledTintColor: disabledTintColor)
        }
        
        return actionView
    }
    
    private func updateAppearance(for actionView: ActionView, action: Alert.Action, disabledTintColor: UIColor?) {
        actionView.isEnabled = action.isEnabled
        actionView.titleLabel.text = action.title
        
        let disabledTintColor = disabledTintColor ?? UIColor(white: 0.48, alpha: 0.8)
        
        switch action.style {
        case .default:
            actionView.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            actionView.titleLabel.textColor = action.isEnabled ? tintColor : disabledTintColor
        case .primary:
            actionView.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            actionView.titleLabel.textColor = action.isEnabled ? tintColor : disabledTintColor
        case let .custom(font, textColor):
            actionView.titleLabel.font = font
            actionView.titleLabel.textColor = action.isEnabled ? textColor : disabledTintColor
        }
    }
    
    private func makeButtonSeparatorView(viewModel: AlertActionSequenceViewModel) -> UIView {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = viewModel.separatorColor
        separatorView.widthAnchor.constraint(equalToConstant: viewModel.separatorWidth).isActive = true
        return separatorView
    }
    
    // MAKR: - Touch Handling
    
    // MARK: UIControl Events
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        highlightView(for: touch, withHapticFeedback: false)
        return result
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.continueTracking(touch, with: event)
        highlightView(for: touch, withHapticFeedback: true)
        return result
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        resetHighlight()
        if let selectedView = selectedView(for: touch) {
            handleTap(on: selectedView)
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        resetHighlight()
    }
    
    // MARK: Selection
    
    private func highlightView(for touch: UITouch, withHapticFeedback: Bool) {
        let point = touch.location(in: self)
        
        for case let actionView as ActionView in stackView.arrangedSubviews {
            guard let actionViewFrame = actionView.superview?.convert(actionView.frame, to: self) else {
                continue
            }
            let isHighlighted = actionViewFrame.contains(point) && actionView.isEnabled
            actionView.isHighlighted = isHighlighted
            
            if isHighlighted, highlightedView != actionView {
                if withHapticFeedback {
                    selectionFeedbackGenerator.selectionChanged()
                    selectionFeedbackGenerator.prepare()
                }
                highlightedView = actionView
            }
        }
    }
    
    private func resetHighlight() {
        for case let actionView as ActionView in stackView.arrangedSubviews {
            actionView.isHighlighted = false
        }
        highlightedView = nil
    }
    
    private func selectedView(for touch: UITouch?) -> ActionView? {
        guard let point = touch?.location(in: self) else {
            return nil
        }
        for case let actionView as ActionView in stackView.arrangedSubviews {
            guard let actionViewFrame = actionView.superview?.convert(actionView.frame, to: self) else {
                continue
            }
            if actionViewFrame.contains(point) {
                return actionView
            }
        }
        return nil
    }
    
    @objc private func handleTap(on actionView: ActionView) {
        let index = stackView.arrangedSubviews
            .compactMap { $0 as? ActionView }
            .filter { $0.isEnabled }
            .firstIndex(where: { $0 === actionView })
        
        if let index = index {
            delegate?.alertActionSequenceView(self, tappedAtIndex: index)
        }
    }
}
