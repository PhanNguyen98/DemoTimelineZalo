//
//  CreatePostViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class CreatePostViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    private let createPostView = CreatePostView()
    let mediaPickerManager = MediaPickerManager()
    
    private let maxVisibleImages = 5
    
    var dataImages: [UIImage] = [] {
        didSet {
            updateImagesUI()
        }
    }
    var videoURL: URL? {
        didSet {
            updateVideoUI()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        videoURL = nil
        
        contentView.addSubview(createPostView)
        contentView.addSubview(createPostView.toolbar)
        
        createPostView.translatesAutoresizingMaskIntoConstraints = false
        createPostView.toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createPostView.topAnchor.constraint(equalTo: contentView.topAnchor),
            createPostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            createPostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            createPostView.bottomAnchor.constraint(equalTo: createPostView.toolbar.topAnchor),
            
            createPostView.toolbar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            createPostView.toolbar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            createPostView.toolbar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            createPostView.toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        mediaPickerManager.delegate = self
        createPostView.imageView.delegate = self
        createPostView.videoView.delegate = self
    }
    
    private func setupActions() {
        createPostView.toolbar.onImageButtonTapped = { [weak self] in
            guard let self = self else { return }
            mediaPickerManager.presentImagePicker(from: self)
            createPostView.toolbar.setImageButtonSelected(true)
        }
        
        createPostView.toolbar.onVideoButtonTapped = { [weak self] in
            guard let self = self else { return }
            mediaPickerManager.presentVideoPicker(from: self)
            createPostView.toolbar.setVideoButtonSelected(true)
        }
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        guard let info = notification.userInfo,
              let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        createPostView.toolbar.transform = CGAffineTransform(translationX: 0, y: -kbFrame.height + 30)
        createPostView.toolbar.setButtonNormal()
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        createPostView.toolbar.transform = .identity
    }
    
    @IBAction func onPressClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onPressSend(_ sender: Any) {
    }
    
    private func updateImagesUI() {
        createPostView.imageView.isHidden = dataImages.isEmpty
        createPostView.toolbar.setVideoButtonDisabled(!dataImages.isEmpty)
        createPostView.imageView.configure(images: dataImages)
    }
    
    private func updateVideoUI() {
        createPostView.videoView.isHidden = (videoURL == nil)
        createPostView.videoView.videoURL = videoURL
        createPostView.toolbar.setImageButtonDisabled(videoURL != nil)
    }
}

// MARK: MediaPickerManagerDelegate
extension CreatePostViewController: MediaPickerManagerDelegate {
    func mediaPickerManager(_ manager: MediaPickerManager, didPickImages images: [UIImage]) {
        DispatchQueue.main.async {
            self.dataImages += images
            self.updateImagesUI()
        }
    }
    
    func mediaPickerManager(_ manager: MediaPickerManager, didPickVideo url: URL) {
        DispatchQueue.main.async {
            self.videoURL = url
        }
    }
}

// MARK: SelectedImagesViewDelegate
extension CreatePostViewController: SelectedImagesViewDelegate {
    func selectedImagesView(_ view: SelectedImagesView, didSelectImage image: UIImage, at index: Int) {
        if index == maxVisibleImages - 1 && dataImages.count > maxVisibleImages {
            let selectedImagesVC = SelectedImagesViewController.instantiate(from: .createPost)
            selectedImagesVC.dataImages = dataImages
            selectedImagesVC.delegate = self
            selectedImagesVC.modalPresentationStyle = .overFullScreen
            present(selectedImagesVC, animated: true)
        } else {
            presentImageDetail(with: image)
        }
    }
    
    func selectedImagesViewDidTapAddImage(_ view: SelectedImagesView) {
        mediaPickerManager.presentImagePicker(from: self)
        createPostView.toolbar.setImageButtonSelected(true)
    }
    
    func selectedImagesView(_ view: SelectedImagesView, didDeleteImageAt index: Int) {
        DispatchQueue.main.async {
            self.dataImages.remove(at: index)
        }
    }
}

// MARK: SelectedImagesViewControllerDelegate
extension CreatePostViewController: SelectedImagesViewControllerDelegate {
    func selectedImagesViewController(_ controller: SelectedImagesViewController, didSelectImages images: [UIImage]) {
        DispatchQueue.main.async {
            self.dataImages = images
        }
    }
}

// MARK: SelectedVideoViewDelegate
extension CreatePostViewController: SelectedVideoViewDelegate {
    func selectedVideoViewDidTapPlay(_ view: SelectedVideoView) {
        let videoDetailVC = VideoDetailViewController.instantiate(from: .createPost)
        videoDetailVC.videoURL = videoURL
        videoDetailVC.modalPresentationStyle = .overFullScreen
        videoDetailVC.modalTransitionStyle = .crossDissolve
        present(videoDetailVC, animated: true)
    }
    
    func selectedVideoViewDidTapDelete(_ view: SelectedVideoView) {
        DispatchQueue.main.async {
            self.videoURL = nil
        }
    }
}
