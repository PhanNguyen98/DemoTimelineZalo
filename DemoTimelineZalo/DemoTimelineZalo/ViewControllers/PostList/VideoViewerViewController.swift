//
//  VideoViewerViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 26/8/25.
//

import UIKit
import AVFoundation

class VideoViewerViewController: BaseViewController {
    
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playView: UIStackView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var video: VideoModel?
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserver: Any?
    private var isControlsVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupOverlayTap()
        setupOverlaySwipeDown()
    }
    private func setupOverlaySwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(overlaySwipedDown))
        swipeDown.direction = .down
        overlayView.addGestureRecognizer(swipeDown)
    }

    
    private func setupPlayer() {
        guard let path = video?.path else { return }
        player = AVPlayer(url: MediaFileManager.urlFromPath(path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = contentView.bounds
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
        }
        
        // Observe when player finishes playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        // Add periodic time observer to update UI
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
            self?.updateTimeUI()
        })
        
        // Setup slider max value and duration label
        if let duration = player?.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds(duration)
            if seconds.isFinite {
                playSlider.maximumValue = Float(seconds)
                durationLabel.text = self.formatTime(seconds: seconds)
            }
        }
        
        // Start playing automatically
        player?.play()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    private func setupOverlayTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func overlayTapped() {
        isControlsVisible.toggle()
        playView.isHidden = !isControlsVisible
        closeButton.isHidden = !isControlsVisible
    }
    
    @objc private func overlaySwipedDown() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateTimeUI() {
        guard let player = player else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        if currentTime.isFinite {
            playSlider.value = Float(currentTime)
            currentTimeLabel.text = formatTime(seconds: currentTime)
        }
    }
    
    private func formatTime(seconds: Double) -> String {
        guard seconds.isFinite else { return "00:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    @IBAction func onPressClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        let seconds = Double(slider.value)
        let targetTime = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: targetTime)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
}
