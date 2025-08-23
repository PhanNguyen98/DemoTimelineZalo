//
//  SelectedVideoView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 23/8/25.
//

import UIKit
import AVKit

class SelectedVideoView: UIView {
    var videoURL: URL? {
        didSet { updateVideos() }
    }
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateVideos() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let url = videoURL else { return }
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        playerVC.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(playerVC.view)
    }
}
