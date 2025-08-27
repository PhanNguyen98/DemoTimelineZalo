//
//  AppRouter.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit
import PanModal

struct AppRouter {
    static func presentImageDetail(from vc: UIViewController, with image: UIImage) {
        let imageDetailVC = ImageDetailViewController.instantiate(from: .createPost)
        imageDetailVC.image = image
        imageDetailVC.modalPresentationStyle = .overFullScreen
        imageDetailVC.modalTransitionStyle = .crossDissolve
        vc.present(imageDetailVC, animated: true)
    }
    
    static func presentCreatePostVC(from vc: UIViewController, entryMode: CreatePostEntryMode = .normal, animated: Bool = true) {
        let createPostVC = CreatePostViewController.instantiate(from: .createPost)
        createPostVC.entryMode = entryMode
        createPostVC.modalPresentationStyle = .overFullScreen
        createPostVC.modalTransitionStyle = .crossDissolve
        vc.present(createPostVC, animated: animated)
    }
    
    static func presentEditPostVC(from vc: UIViewController, post: PostModel) {
        let createPostVC = CreatePostViewController.instantiate(from: .createPost)
        createPostVC.editingPost = post
        createPostVC.modalPresentationStyle = .overFullScreen
        vc.present(createPostVC, animated: true)
    }
    
    static func presentVideoDetail(from vc: UIViewController, with videoURL: URL) {
        let videoDetailVC = VideoDetailViewController.instantiate(from: .createPost)
        videoDetailVC.videoURL = videoURL
        videoDetailVC.modalPresentationStyle = .overFullScreen
        videoDetailVC.modalTransitionStyle = .crossDissolve
        vc.present(videoDetailVC, animated: true)
    }
    
    static func presentSelectedImages(from vc: UIViewController, dataImages: [UIImage], delegate: SelectedImagesViewControllerDelegate?) {
        let selectedImagesVC = SelectedImagesViewController.instantiate(from: .createPost)
        selectedImagesVC.dataImages = dataImages
        selectedImagesVC.delegate = delegate
        selectedImagesVC.modalPresentationStyle = .overFullScreen
        vc.present(selectedImagesVC, animated: true)
    }
    
    static func presentOptionsMenu(from vc: UIViewController, post: PostModel, delegate: OptionsViewControllerDelegate?) {
        let optionVC = OptionsViewController()
        optionVC.post = post
        optionVC.delegate = delegate
        vc.presentPanModal(optionVC)
    }
    
    static func presentVideoViewer(from vc: UIViewController, video: VideoModel) {
        let videoViewerVC = VideoViewerViewController.instantiate(from: .postList)
        videoViewerVC.video = video
        videoViewerVC.modalPresentationStyle = .overFullScreen
        videoViewerVC.modalTransitionStyle = .crossDissolve
        vc.present(videoViewerVC, animated: true)
    }
    
    static func pushtoPostDetail(from vc: UIViewController, post: PostModel) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.post = post
        vc.push(postDetailVC)
    }
    
    static func presentSearchViewController(from vc: UIViewController) {
        let searchVC = PostSearchViewController.instantiate(from: .postSearch)
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.modalTransitionStyle = .crossDissolve
        searchNav.modalPresentationStyle = .overFullScreen
        vc.present(searchNav, animated: true)
    }
}

