//
//  ReactionView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 28/8/25.
//

import UIKit

class ReactionView: UIControl {
    
    private weak var highlightedButton: UIButton?

    private var selectionView: UIStackView?
    private var dismissOverlay: UIView?
    
    private let leftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let reactionIconLarge: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 24),
            imgView.heightAnchor.constraint(equalToConstant: 24)
        ])
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Thích"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }()
    
    private let rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let reactionIconSmall: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.layer.cornerRadius = 8
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 1
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 16),
            imgView.heightAnchor.constraint(equalToConstant: 16)
        ])
        return imgView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.isHidden = true
        return label
    }()
    
    private var currentReaction: ReactionType? = nil
    private var likeCount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }
}

// MARK: - UI Setup
extension ReactionView {
    private func setupUI() {
        backgroundColor = .colorF3F5F6
        
        leftStack.addArrangedSubview(reactionIconLarge)
        leftStack.addArrangedSubview(titleLabel)
        
        rightStack.addArrangedSubview(reactionIconSmall)
        rightStack.addArrangedSubview(countLabel)
        
        let mainStack = UIStackView(arrangedSubviews: [leftStack, separatorView, rightStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        mainStack.alignment = .center
        
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            separatorView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        resetToDefaultState()
    }
    
    private func resetToDefaultState() {
        currentReaction = nil
        likeCount = 0
        updateLabels(for: nil)
        updateReactionIcons()
        updateVisibility()
    }
    
    private func updateLabels(for reaction: ReactionType?) {
        if let reaction = reaction {
            titleLabel.text = reaction.title
            titleLabel.textColor = reaction.color
            countLabel.textColor = reaction.color
        } else {
            titleLabel.text = "Thích"
            titleLabel.textColor = .darkGray
            countLabel.textColor = .darkGray
        }
    }
    
    private func updateVisibility() {
        let hasReaction = currentReaction != nil
        separatorView.isHidden = !hasReaction
        rightStack.isHidden = !hasReaction
        titleLabel.isHidden = hasReaction
        countLabel.isHidden = likeCount == 0
    }
}

// MARK: - Gesture Handling
extension ReactionView {
    private func setupGestures() {
        addTapGesture(target: self, action: #selector(handleTap))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        addGestureRecognizer(longPress)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let stack = gesture.view as? UIStackView else { return }
        let location = gesture.location(in: stack)
        
        let targetButton = stack.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .min(by: { lhs, rhs in
                let lhsDist = hypot(lhs.center.x - location.x, lhs.center.y - location.y)
                let rhsDist = hypot(rhs.center.x - location.x, rhs.center.y - location.y)
                return lhsDist < rhsDist
            })
        
        if let targetButton = targetButton {
            if highlightedButton != targetButton {
                // Reset old
                if let old = highlightedButton {
                    UIView.animate(withDuration: 0.05) {
                        old.transform = .identity
                        old.backgroundColor = .clear
                    }
                }
                // Highlight new
                highlightedButton = targetButton
                UIView.animate(withDuration: 0.05) {
                    targetButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                        .concatenating(CGAffineTransform(translationX: 0, y: -7))
                    targetButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
                }
            }
        }
        if gesture.state == .ended, let selected = highlightedButton {
            didSelectReaction(selected)
        }
    }
}

// MARK: - Reaction Handling
extension ReactionView {
    @objc private func handleTap() {
        if let current = currentReaction {
            toggleReaction(nil, decrement: true)
        } else {
            toggleReaction(.like, decrement: false)
        }
    }
    
    @objc private func didSelectReaction(_ sender: UIButton) {
        guard let selectedReaction = ReactionType(rawValue: sender.tag) else { return }
        if currentReaction == selectedReaction {
            toggleReaction(nil, decrement: true)
        } else {
            toggleReaction(selectedReaction, decrement: false)
        }
        highlightedButton = nil
        dismissSelectionView()
    }
    
    private func toggleReaction(_ reaction: ReactionType?, decrement: Bool) {
        if decrement {
            likeCount = max(0, likeCount - 1)
        } else if currentReaction == nil {
            likeCount += 1
        }
        currentReaction = reaction
        
        updateLabels(for: currentReaction)
        updateVisibility()
        updateReactionIcons()
        animateReactionView()
        countLabel.text = "\(likeCount)"
        sendActions(for: .valueChanged)
    }
}

// MARK: - Popup Handling
extension ReactionView {
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let selectionStack = createSelectionView()
        self.selectionView = selectionStack
        
        selectionStack.translatesAutoresizingMaskIntoConstraints = false
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelectionView))
        overlay.addGestureRecognizer(tapGesture)
        
        window.addSubview(overlay)
        overlay.addSubview(selectionStack)
        
        self.dismissOverlay = overlay
        
        NSLayoutConstraint.activate([
            selectionStack.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            selectionStack.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -10)
        ])
        
        selectionStack.alpha = 0
        selectionStack.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            selectionStack.alpha = 1
            selectionStack.transform = .identity
        }
    }
    
    private func createSelectionView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.backgroundColor = .colorF3F5F6
        stack.layer.cornerRadius = 24
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.layer.shadowColor = UIColor.black.cgColor
        stack.layer.shadowOpacity = 0.15
        stack.layer.shadowRadius = 6
        stack.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        for reaction in ReactionType.allCases {
            let button = UIButton(type: .custom)
            button.setImage(reaction.icon, for: .normal)
            button.tintColor = .clear
            button.tag = reaction.rawValue
            button.addTarget(self, action: #selector(didSelectReaction(_:)), for: .touchUpInside)
            
            button.widthAnchor.constraint(equalToConstant: 36).isActive = true
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            button.layer.cornerRadius = 18
            button.clipsToBounds = true
            
            button.addTarget(self, action: #selector(reactionButtonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(reactionButtonTouchUp(_:)), for: [.touchUpInside, .touchDragExit, .touchCancel])
            
            stack.addArrangedSubview(button)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        stack.addGestureRecognizer(panGesture)
        
        return stack
    }
    
    @objc private func dismissSelectionView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.selectionView?.alpha = 0
            self.selectionView?.transform = CGAffineTransform(translationX: 0, y: 20)
        }) { _ in
            self.selectionView?.removeFromSuperview()
            self.dismissOverlay?.removeFromSuperview()
            self.selectionView = nil
            self.dismissOverlay = nil
            self.highlightedButton = nil
        }
    }
}

// MARK: - Animations
extension ReactionView {
    @objc private func reactionButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            sender.backgroundColor = UIColor(white: 0.9, alpha: 1)
        }
    }

    @objc private func reactionButtonTouchUp(_ sender: UIButton) {
        if sender != highlightedButton {
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
                sender.backgroundColor = .clear
            }
        }
    }
    
    private func animateReactionView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}

// MARK: - Icon Updates
extension ReactionView {
    private func updateReactionIcons() {
        if let reaction = currentReaction, likeCount > 0 {
            reactionIconLarge.image = reaction.icon
            reactionIconSmall.image = reaction.icon
            countLabel.text = "\(likeCount)"
            countLabel.isHidden = false
            titleLabel.isHidden = false
            
            separatorView.isHidden = false
            rightStack.isHidden = false
            
            reactionIconSmall.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 3,
                           options: .curveEaseOut) {
                self.reactionIconSmall.transform = .identity
            }
        } else {
            reactionIconLarge.image = ReactionType.like.iconDefault
            reactionIconSmall.image = nil
            countLabel.text = nil
            countLabel.isHidden = true
            titleLabel.isHidden = false
            titleLabel.text = "Thích"
            titleLabel.textColor = .colorACAFB2
            countLabel.textColor = .colorACAFB2
            
            separatorView.isHidden = true
            rightStack.isHidden = true
        }
    }
}
