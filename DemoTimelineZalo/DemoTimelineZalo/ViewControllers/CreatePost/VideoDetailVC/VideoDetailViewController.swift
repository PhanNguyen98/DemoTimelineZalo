//
//  VideoDetailViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 24/8/25.
//

import UIKit
import AVFoundation

class VideoDetailViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying: Bool = false
    private let overlayIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.alpha = 0
        return imageView
    }()
    
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = contentView.bounds
    }
    
    func setupUI() {
        // Setup AVPlayer
        if let url = videoURL {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = contentView.bounds
            playerLayer?.videoGravity = .resizeAspect
            if let playerLayer = playerLayer {
                contentView.layer.addSublayer(playerLayer)
            }
            
            player?.play()
            isPlaying = true
        }
        
        // Thêm overlay icon
        contentView.addSubview(overlayIcon)
        overlayIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            overlayIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            overlayIcon.widthAnchor.constraint(equalToConstant: 50),
            overlayIcon.heightAnchor.constraint(equalTo: overlayIcon.widthAnchor, multiplier: 1)
        ])
        
        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
            showOverlayIcon(systemName: "play.fill")
        } else {
            player.play()
            showOverlayIcon(systemName: "pause.fill")
        }
        isPlaying.toggle()
    }
    
    private func showOverlayIcon(systemName: String) {
        overlayIcon.image = UIImage(systemName: systemName)
        overlayIcon.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: []) {
            self.overlayIcon.alpha = 0
        }
    }
    
    @IBAction func onPressClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onPressDone(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
