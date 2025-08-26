//
//  ImagePostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit
import JXPhotoBrowser

protocol ImagePostContentViewDelegate: AnyObject {
    func imagePostContentView(_ view: ImagePostContentView, didSelectImageAt index: Int, image: ImageModel, post: PostModel)
}

class ImagePostContentView: BasePostContentView {
    
    private let mediaCollectionView: UICollectionView = {
        let layout = PostImageLayout()
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
    
    private var currentPost: PostModel?
    private var mediaCollectionHeightConstraint: NSLayoutConstraint?
    private var dataImage: [ImageModel] = []
    
    weak var delegate: ImagePostContentViewDelegate?
    
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
    func configure(post: PostModel) {
        currentPost = post
        configureContent(text: post.content)
        mediaCollectionHeightConstraint?.constant = PostImageLayout.heightForItemCount(currentPost?.images?.count ?? 0)
        mediaCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension ImagePostContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let images = currentPost?.images, let post = currentPost else { return }
        let selectedImage = images[indexPath.row]
        delegate?.imagePostContentView(self, didSelectImageAt: indexPath.row, image: selectedImage, post: post)
        
        guard let images = post.images else { return }
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            images.count
        }
        browser.reloadCellAtIndex = { context in
            let url = images[context.index].path.flatMap { URL(fileURLWithPath: $0) }
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            guard let imageView = browserCell?.imageView else { return }
            MediaFileManager.loadImage(from: url, into: imageView)
        }
        browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? PostImageCollectionViewCell
            return cell?.postImageView
        })
        browser.pageIndicator = JXPhotoBrowserNumberPageIndicator()
        browser.pageIndex = indexPath.item
        browser.show()
    }
}

// MARK: -UICollectionDataSource
extension ImagePostContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = currentPost?.images else { return 0 }
        if images.count > 5 {
            return 5
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let row = indexPath.row
        guard let images = currentPost?.images else { return cell }
        cell.configureImage(image: images[row], index: row, totalImages: images.count)
        return cell
    }
}
