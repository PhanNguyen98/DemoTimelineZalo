//
//  PostFooterView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 28/8/25.
//

import UIKit

class PostFooterView: UIView {
    private let reactionView: ReactionView = {
        let view = ReactionView()
        view.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .colorF3F5F6
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        let commentImage = UIImage(systemName: "text.bubble", withConfiguration: config)?.withTintColor(.colorACAFB2, renderingMode: .alwaysOriginal)
        button.setImage(commentImage, for: .normal)
        button.setTitle(nil, for: .normal)
        button.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [reactionView, commentButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            reactionView.heightAnchor.constraint(equalToConstant: 36),
            commentButton.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
}

