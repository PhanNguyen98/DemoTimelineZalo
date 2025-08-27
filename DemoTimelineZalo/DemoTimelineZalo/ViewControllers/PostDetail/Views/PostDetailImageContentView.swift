//
//  PostDetailImageContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 27/8/25.
//

import UIKit
import JXPhotoBrowser

protocol PostDetailImageContentViewDelegate: AnyObject {
    func imagePostContentView(_ view: PostDetailImageContentView, didSelectImageAt index: Int, image: ImageModel, post: PostModel)
}

class PostDetailImageContentView: BasePostContentView {
    
    private let mediaCollectionView: UICollectionView = {
        let layout = PostDetailImageLayout()
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
    
    weak var delegate: PostDetailImageContentViewDelegate?
    
    // MARK: - Setup
    override func setupUI() {
        super.setupUI()
        let stack = UIStackView(arrangedSubviews: [mediaCollectionView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
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
        mediaCollectionHeightConstraint?.constant = PostDetailImageLayout.heightForItemCount(currentPost?.images?.count ?? 0)
        mediaCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension PostDetailImageContentView: UICollectionViewDelegate {
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
            let url = images[context.index].path.flatMap { MediaFileManager.urlFromPath($0) }
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
extension PostDetailImageContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = currentPost?.images else { return 0 }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let row = indexPath.row
        guard let images = currentPost?.images else { return cell }
        cell.configureImage(image: images[row])
        return cell
    }
}

