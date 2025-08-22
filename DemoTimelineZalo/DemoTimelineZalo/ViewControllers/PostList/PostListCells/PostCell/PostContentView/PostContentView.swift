//
//  PostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit
import AVKit

class PostContentView: UIView {
    
    // MARK: - UI Components
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mediaCollectionView: UICollectionView = {
        let layout = PostImageLayout()
        layout.numberOfColumns = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let view = GradientView()
        view.startColor = .color61ABF1
        view.endColor = .colorF3F5F6
        view.startPoint = .init(x: 0, y: 0)
        view.endPoint = .init(x: 1, y: 1)
        collectionView.backgroundView = view
        collectionView.backgroundColor = .clear
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true
        
        collectionView.register(PostImageCollectionViewCell.self, bundle: .main)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var playerLayer: AVPlayerLayer?
    private var currentPost: Post?
    private var mediaCollectionHeightConstraint: NSLayoutConstraint?
    private var countImage: Int = 5
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(contentLabel)
        addSubview(videoContainerView)
        addSubview(mediaCollectionView)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            videoContainerView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            videoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            videoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            videoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            videoContainerView.heightAnchor.constraint(equalTo: videoContainerView.widthAnchor, multiplier: 3/2),
            
            mediaCollectionView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            mediaCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        mediaCollectionHeightConstraint = mediaCollectionView.heightAnchor.constraint(equalToConstant: 0)
        mediaCollectionHeightConstraint?.isActive = true
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
    
    // MARK: - Configure
    func configure() {
        contentLabel.text = "Hello, World!"
        contentLabel.isHidden = false
        mediaCollectionView.isHidden = false
        videoContainerView.isHidden = true
        
        mediaCollectionHeightConstraint?.constant = PostImageLayout.heightForItemCount(countImage)
    }
}

// MARK: - UICollectionViewDelegate
extension PostContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

// MARK: -UICollectionDataSource
extension PostContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let images = currentPost?.images else { return 0 }
//        if images.count > 5 {
//            return 5
//        }
//        return images.count
        return countImage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
