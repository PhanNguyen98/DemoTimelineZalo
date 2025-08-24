//
//  DiaryToolbarView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 23/8/25.
//

import UIKit

class DiaryToolbarView: UIView {
    
    private let topBorder = CALayer()
    
    var onImageButtonTapped: (() -> Void)?
    var onVideoButtonTapped: (() -> Void)?
    
    let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let videoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.rectangle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topBorder.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }
    
    private func setupUI() {
        topBorder.backgroundColor = UIColor.colorACAFB2.cgColor
        layer.addSublayer(topBorder)
        
        setButtonNormal()
        
        let stackView = UIStackView(arrangedSubviews: [imageButton, videoButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            imageButton.widthAnchor.constraint(equalTo: imageButton.heightAnchor),
        ])
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
    }
    
    func styleButton(_ button: UIButton, selected: Bool) {
        if selected {
            button.tintColor = .blue
        } else {
            button.tintColor = .black
        }
    }
    
    func setImageButtonSelected(_ selected: Bool) {
        styleButton(imageButton, selected: selected)
        styleButton(videoButton, selected: !selected)
    }
    
    func setVideoButtonSelected(_ selected: Bool) {
        styleButton(videoButton, selected: selected)
        styleButton(imageButton, selected: !selected)
    }
    
    func setButtonNormal() {
        styleButton(imageButton, selected: false)
        styleButton(videoButton, selected: false)
    }
    
    func setVideoButtonDisabled(_ disabled: Bool) {
        videoButton.isEnabled = !disabled
    }
    
    func setImageButtonDisabled(_ disabled: Bool) {
        imageButton.isEnabled = !disabled
    }
    
    @objc private func imageButtonTapped() {
        onImageButtonTapped?()
    }

    @objc private func videoButtonTapped() {
        onVideoButtonTapped?()
    }
    
}
