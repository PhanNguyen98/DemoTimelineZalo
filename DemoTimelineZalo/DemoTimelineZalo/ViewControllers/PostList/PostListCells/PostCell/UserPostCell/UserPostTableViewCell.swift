//
//  UserPostTableViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

// Delegate protocol to handle user interactions in UserPostTableViewCell
protocol UserPostTableViewCellDelegate: AnyObject {
    func didTapContent(in cell: UserPostTableViewCell, post: PostModel)
}

class UserPostTableViewCell: BasePostTableViewCell {
    
    weak var delegate: UserPostTableViewCellDelegate?
    
    private let headerView: PostHeaderView = {
        let view = PostHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageContentView: ImagePostContentView = {
        let view = ImagePostContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let videoContentView: VideoPostContentView = {
        let view = VideoPostContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentPost: PostModel?
    
    override func setupUI() {
        super.setupUI()
        let stack = UIStackView(arrangedSubviews: [headerView, imageContentView, videoContentView])
        stack.axis = .vertical
        stack.spacing = 8
        contentView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: lineView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(post: PostModel,
                   imageDelegate: ImagePostContentViewDelegate?,
                   videoDelegate: VideoPostContentViewDelegate?) {
        currentPost = post
        let hasVideo = post.video != nil
        videoContentView.isHidden = !hasVideo
        imageContentView.isHidden = hasVideo
        
        if let video = post.video {
            videoContentView.didTapContentLabel = { [weak self] in
                guard let self = self, let currentPost = self.currentPost else { return }
                self.delegate?.didTapContent(in: self, post: currentPost)
            }
            videoContentView.delegate = videoDelegate
            videoContentView.configure(video: video)
            videoContentView.configureContent(text: post.content)
        } else {
            imageContentView.didTapContentLabel = { [weak self] in
                guard let self = self, let currentPost = self.currentPost else { return }
                self.delegate?.didTapContent(in: self, post: currentPost)
            }
            imageContentView.delegate = imageDelegate
            imageContentView.configureContent(text: post.content)
            imageContentView.configure(post: post)
        }
    }
    
    func configureWillDisplay(post: PostModel) {
        let hasVideo = post.video != nil
        
        if hasVideo {
            playVideoIfExists()
        }
    }
    
    func configureEndDisplay(post: PostModel) {
        let hasVideo = post.video != nil
        
        if hasVideo {
            pauseVideoIfExists()
        }
    }
    
    func playVideoIfExists() {
        videoContentView.playVideo()
    }

    func pauseVideoIfExists() {
        videoContentView.pauseVideo()
    }
    
    func configureHeader(post: PostModel, delegate: PostHeaderViewDelegate) {
        headerView.delegate = delegate
        headerView.configure(post: post)
    }
}
