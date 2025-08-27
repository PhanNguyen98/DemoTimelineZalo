//
//  CustomNavigationView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 27/8/25.
//

import UIKit

protocol CustomNavigationViewDelegate: AnyObject {
    func navigationViewDidTapBack(_ navigationView: CustomNavigationView)
}

class CustomNavigationView: GradientView {

    weak var delegate: CustomNavigationViewDelegate?

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let arrowImage = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        button.setImage(arrowImage, for: .normal)
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
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        startColor = .color4B85FB
        endColor = .color61ABF1
        startPoint = .init(x: 0, y: 0)
        endPoint = .init(x: 1, y: 1)
    }
    
    @objc private func backButtonTapped() {
        delegate?.navigationViewDidTapBack(self)
    }
}
