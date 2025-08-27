//
//  PostDetailViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class PostDetailViewController: BaseViewController {
    
    private let navigationView: CustomNavigationView = {
        let view = CustomNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: PostHeaderView = {
        let view = PostHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageContentView: PostDetailImageContentView = {
        let view = PostDetailImageContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let videoContentView: VideoPostContentView = {
        let view = VideoPostContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var post: PostModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupData()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        // Add navigationView
        view.addSubview(navigationView)
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        // Setup scrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.delegate = self
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup stackView
        let stackView = UIStackView(arrangedSubviews: [headerView, imageContentView, videoContentView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        navigationView.delegate = self
    }
    
    func setupData() {
        guard let post = post else { return }
        let hasVideo = post.video != nil
        videoContentView.isHidden = !hasVideo
        imageContentView.isHidden = hasVideo
        
        if let video = post.video {
            videoContentView.delegate = self
            videoContentView.configure(video: video)
            videoContentView.configureFullContent(text: post.content)
        } else {
            imageContentView.configure(post: post)
            imageContentView.configureFullContent(text: post.content)
        }
        headerView.configure(post: post)
        headerView.setHiddenMoreButton(true)
    }
    
    func playVideoIfExists() {
        videoContentView.playVideo()
    }

    func pauseVideoIfExists() {
        videoContentView.pauseVideo()
    }
    
    func muteVideoIfNeeded(whileScrolling scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            videoContentView.muteVideo(true)
        } 
    }
}

extension PostDetailViewController: VideoPostContentViewDelegate {
    func videoPostContentViewDidTap(_ view: VideoPostContentView, video: VideoModel) {
        pauseVideoIfExists()
        AppRouter.presentVideoViewer(from: self, video: video)
    }
}

extension PostDetailViewController: CustomNavigationViewDelegate {
    func navigationViewDidTapBack(_ navigationView: CustomNavigationView) {
        pop()
    }
}

extension PostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        muteVideoIfNeeded(whileScrolling: scrollView)
    }
}
