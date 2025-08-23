//
//  SelectedImagesView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 23/8/25.
//


import UIKit

protocol SelectedImagesViewDelegate: AnyObject {
    func selectedImagesViewDidTapAddImage(_ view: SelectedImagesView)
    func selectedImagesView(_ view: SelectedImagesView, didDeleteImageAt index: Int)
}

class SelectedImagesView: UIView {
    private let mediaCollectionView: UICollectionView = {
        let layout = PostImageLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.cornerRadius = 8
        collectionView.backgroundColor = .colorF3F5F6
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        collectionView.register(PostImageCollectionViewCell.self, bundle: .main)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Thêm ảnh", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.titleLabel?.textColor = .black
        button.backgroundColor = .colorF3F5F6
        button.cornerRadius = 18
        button.isHidden = true
        return button
    }()
    
    weak var delegate: SelectedImagesViewDelegate?
    
    private var mediaCollectionHeightConstraint: NSLayoutConstraint?
    private var dataImages: [UIImage] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [mediaCollectionView, addImageButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mediaCollectionView.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            mediaCollectionView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            
            addImageButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 16),
            addImageButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -16),
            addImageButton.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        mediaCollectionHeightConstraint = mediaCollectionView.heightAnchor.constraint(equalToConstant: 0)
        mediaCollectionHeightConstraint?.isActive = true
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        addImageButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
    }
    
    @objc private func addImageTapped() {
        delegate?.selectedImagesViewDidTapAddImage(self)
    }
    
    // MARK: - Configure
    func configure(images: [UIImage]) {
        dataImages = images
        mediaCollectionHeightConstraint?.constant = PostImageLayout.heightForItemCount(images.count)
        addImageButton.isHidden = images.isEmpty
        mediaCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension SelectedImagesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

// MARK: -UICollectionDataSource
extension SelectedImagesView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataImages.count > 5 {
            return 5
        }
        return dataImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell: PostImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(image: dataImages[row], index: row, totalImages: dataImages.count)
        cell.onDeleteTapped = { [weak self] in
            guard let self = self else { return }
            self.delegate?.selectedImagesView(self, didDeleteImageAt: row)
            dataImages.remove(at: row)
            mediaCollectionView.reloadData()
        }
        return cell
    }
}
