//
//  ReactionContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 28/8/25.
//


import UIKit

class ReactionContentView: UIView {
    private let reactionView: ReactionView = {
        let view = ReactionView()
        view.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(reactionView)
        NSLayoutConstraint.activate([
            reactionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            reactionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            reactionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            reactionView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
