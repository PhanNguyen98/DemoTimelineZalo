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
    
    var dataImages: [UIImage] = [] {
        didSet {
            createPostView.imageView.isHidden = dataImages.isEmpty
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
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
    
}

// MARK: MediaPickerManagerDelegate
extension CreatePostViewController: MediaPickerManagerDelegate {
    func mediaPickerManager(_ manager: MediaPickerManager, didPickImages images: [UIImage]) {
        dataImages = images
        createPostView.imageView.configure(images: images)
    }
    
    func mediaPickerManager(_ manager: MediaPickerManager, didPickVideo url: URL) {
        
    }
}

// MARK: SelectedImagesViewDelegate
extension CreatePostViewController: SelectedImagesViewDelegate {
    func selectedImagesViewDidTapAddImage(_ view: SelectedImagesView) {
        mediaPickerManager.presentImagePicker(from: self)
        createPostView.toolbar.setImageButtonSelected(true)
    }
    
    func selectedImagesView(_ view: SelectedImagesView, didDeleteImageAt index: Int) {
        dataImages.remove(at: index)
    }
}

