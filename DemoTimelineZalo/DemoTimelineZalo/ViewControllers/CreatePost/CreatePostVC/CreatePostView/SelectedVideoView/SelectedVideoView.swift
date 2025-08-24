import UIKit
import AVFoundation

protocol SelectedVideoViewDelegate: AnyObject {
    func selectedVideoViewDidTapPlay(_ view: SelectedVideoView)
    func selectedVideoViewDidTapDelete(_ view: SelectedVideoView)
}

class SelectedVideoView: UIView {
    var videoURL: URL? {
        didSet { updateThumbnail() }
    }
    
    weak var delegate: SelectedVideoViewDelegate?
    
    private let thumbnailImageView = UIImageView()
    private let playButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        clipsToBounds = true
        
        // Thumbnail
        thumbnailImageView.cornerRadius = 8
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.isUserInteractionEnabled = true
        addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped))
        thumbnailImageView.addGestureRecognizer(tapGesture)
        
        // Play button
        let playImage = UIImage(systemName: "play.circle.fill")?.withTintColor(.black.withAlphaComponent(0.5), renderingMode: .alwaysOriginal)
        playButton.setImage(playImage, for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Delete button
        let deleteImage = UIImage(systemName: "x.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // Thumbnail fills the whole view
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Aspect ratio 3:2 (height = 1.5 * width)
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.2),
            
            // Play button center
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Delete button top-right
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func playButtonTapped() {
        delegate?.selectedVideoViewDidTapPlay(self)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.selectedVideoViewDidTapDelete(self)
    }
    
    @objc private func thumbnailTapped() {
        delegate?.selectedVideoViewDidTapPlay(self)
    }
    
    private func updateThumbnail() {
        guard let url = videoURL else {
            thumbnailImageView.image = nil
            return
        }
        
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        if let cgImage = try? imageGenerator.copyCGImage(at: .zero, actualTime: nil) {
            thumbnailImageView.image = UIImage(cgImage: cgImage)
        }
    }
}
