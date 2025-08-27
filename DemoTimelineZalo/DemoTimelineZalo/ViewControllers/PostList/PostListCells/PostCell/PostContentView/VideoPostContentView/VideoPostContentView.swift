//
//  VideoPostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit
import AVKit

protocol VideoPostContentViewDelegate: AnyObject {
    func videoPostContentViewDidTap(_ view: VideoPostContentView, video: VideoModel)
}

class VideoPostContentView: BasePostContentView {
    
    weak var delegate: VideoPostContentViewDelegate?
    private var currentVideo: VideoModel?
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let muteButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "speaker.slash.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isMuted: Bool = true {
        didSet {
            player?.isMuted = isMuted
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            let imageName = isMuted ? "speaker.slash.circle.fill" : "speaker.wave.2.circle.fill"
            let image = UIImage(systemName: imageName, withConfiguration: config)
            muteButton.setImage(image, for: .normal)
        }
    }
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    override func setupUI() {
        super.setupUI()
        
        addSubview(videoContainerView)
        addSubview(muteButton)
        
        videoContainerView.addTapGesture(target: self, action: #selector(handleTap))
        
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            videoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            videoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            videoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            videoContainerView.heightAnchor.constraint(equalTo: videoContainerView.widthAnchor, multiplier: 1.3),
            
            muteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            muteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
        
        muteButton.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
    }
    
    func configure(video: VideoModel) {
        self.pauseVideo()
        currentVideo = video
        Task {
            videoContainerView.isHidden = false
            guard let path = video.path else { return }
            let player = AVPlayer(url: MediaFileManager.urlFromPath(path))
            self.player = player
            playerLayer?.removeFromSuperlayer()
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = videoContainerView.bounds
            playerLayer?.videoGravity = .resizeAspectFill
            if let playerLayer = playerLayer {
                videoContainerView.layer.addSublayer(playerLayer)
            }
            player.isMuted = isMuted
            player.play()
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    
    @objc private func handleTap() {
        isMuted = true
        guard let video = currentVideo else { return }
        delegate?.videoPostContentViewDidTap(self, video: video)
    }
    
    @objc private func toggleMute() {
        isMuted.toggle()
    }
    
    func playVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    func pauseVideo() {
        isMuted = true
        player?.pause()
    }

    func muteVideo(_ mute: Bool) {
        isMuted = mute
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }
}
