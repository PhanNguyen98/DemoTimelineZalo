//
//  CustomNavigationView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 27/8/25.
//

import UIKit

protocol CustomNavigationViewDelegate: AnyObject {
    func navigationViewDidTapBack(_ navigationView: CustomNavigationView)
    func navigationViewDidTapMore(_ navigationView: CustomNavigationView)
}

class CustomNavigationView: GradientView {

    weak var delegate: CustomNavigationViewDelegate?

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let arrowImage = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        button.setImage(arrowImage, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        let moreImage = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        button.setImage(moreImage, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(backButton)
        addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moreButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        startColor = .color4B85FB
        endColor = .color61ABF1
        startPoint = .init(x: 0, y: 0)
        endPoint = .init(x: 1, y: 1)
    }
    
    @objc private func backButtonTapped() {
        delegate?.navigationViewDidTapBack(self)
    }
    
    @objc private func moreButtonTapped() {
        delegate?.navigationViewDidTapMore(self)
    }
}
