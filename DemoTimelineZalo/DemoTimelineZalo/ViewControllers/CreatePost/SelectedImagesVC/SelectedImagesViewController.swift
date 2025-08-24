//
//  SelectedImagesViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 24/8/25.
//

import UIKit

protocol SelectedImagesViewControllerDelegate: AnyObject {
    func selectedImagesViewController(_ controller: SelectedImagesViewController, didSelectImages images: [UIImage])
}

class SelectedImagesViewController: BaseViewController {
    private enum SelectedImagesSection: Int, CaseIterable {
        case images = 0
        case addImage
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: SelectedImagesViewControllerDelegate?
    let mediaPickerManager = MediaPickerManager()
    
    var dataImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    func setupUI() {
        mediaPickerManager.delegate = self
        updateTitle()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostImageCollectionViewCell.self, bundle: .main)
        collectionView.register(AddImageCollectionViewCell.self, bundle: .main)
    }
    
    func updateTitle() {
        self.titleLabel.text = "Ảnh đã chọn: \(self.dataImages.count)"
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onPressDone(_ sender: Any) {
        delegate?.selectedImagesViewController(self, didSelectImages: dataImages)
        dismiss(animated: true)
    }
    
}

// MARK: UICollectionViewDelegate & DataSource
extension SelectedImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SelectedImagesSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SelectedImagesSection.allCases[section] {
        case .images:
            return dataImages.count
        case .addImage:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch SelectedImagesSection.allCases[section] {
        case .images:
            let cell: PostImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.postImageView.image = dataImages[row]
            cell.onDeleteTapped = { [weak self] in
                guard let self = self else { return }
                self.dataImages.remove(at: row)
                self.updateTitle()
                self.collectionView.reloadData()
            }
            return cell
        case .addImage:
            let cell: AddImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch SelectedImagesSection.allCases[section] {
        case .images:
            presentImageDetail(with: dataImages[row])
        case .addImage:
            mediaPickerManager.presentImagePicker(from: self)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SelectedImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        switch SelectedImagesSection.allCases[section] {
        case .images:
            let width = (ScreenSize.width - 10) / 3
            return .init(width: width, height: width)
        case .addImage:
            let width = ScreenSize.width - 32
            return .init(width: width, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch SelectedImagesSection.allCases[section] {
        case .images:
            return .zero
        case .addImage:
            return .init(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
}

// MARK: MediaPickerManagerDelegate
extension SelectedImagesViewController: MediaPickerManagerDelegate {
    func mediaPickerManager(_ manager: MediaPickerManager, didPickImages images: [UIImage]) {
        dataImages += images
        updateTitle()
        collectionView.reloadData()
    }
    
    func mediaPickerManager(_ manager: MediaPickerManager, didPickVideo url: URL) {
    }
}
