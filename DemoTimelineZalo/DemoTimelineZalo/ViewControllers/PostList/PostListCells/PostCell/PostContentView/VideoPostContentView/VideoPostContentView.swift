//
//  VideoPostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit
import AVKit

class VideoPostContentView: BasePostContentView {
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var playerLayer: AVPlayerLayer?
    
    override func setupUI() {
        super.setupUI()
        
        addSubview(videoContainerView)
        
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            videoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            videoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            videoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            videoContainerView.heightAnchor.constraint(equalTo: videoContainerView.widthAnchor, multiplier: 3/2),
        ])
    }
    
    func configure(videoURL: URL) {
        videoContainerView.isHidden = false
        
        let player = AVPlayer(url: videoURL)
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            videoContainerView.layer.addSublayer(playerLayer)
        }
        player.play()
    }
}

