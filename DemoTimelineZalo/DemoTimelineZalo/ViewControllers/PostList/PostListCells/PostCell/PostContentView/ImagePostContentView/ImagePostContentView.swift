//
//  ImagePostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class ImagePostContentView: BasePostContentView {
    
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
        
        collectionView.register(PostImageCollectionViewCell.self, bundle: .main)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var currentPost: Post?
    private var mediaCollectionHeightConstraint: NSLayoutConstraint?
    private var countImage: Int = 3
    
    // MARK: - Setup
    override func setupUI() {
        super.setupUI()
        let stack = UIStackView(arrangedSubviews: [mediaCollectionView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        mediaCollectionHeightConstraint = mediaCollectionView.heightAnchor.constraint(equalToConstant: 0)
        mediaCollectionHeightConstraint?.isActive = true
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
    
    // MARK: - Configure
    func configure() {
        configureContent(text: "Hello, World!")
        
        mediaCollectionHeightConstraint?.constant = PostImageLayout.heightForItemCount(countImage)
    }
}

// MARK: - UICollectionViewDelegate
extension ImagePostContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

// MARK: -UICollectionDataSource
extension ImagePostContentView: UICollectionViewDataSource {
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
