//
//  PostHeaderView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

protocol PostHeaderViewDelegate: AnyObject {
    func postHeaderViewDidTapMore(_ headerView: PostHeaderView, post: PostModel)
}

class PostHeaderView: BaseViewXIB {
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: AvatarImageView!
    
    weak var delegate: PostHeaderViewDelegate?
    private var currentPost: PostModel?
    
    override func setUpViews() {
        super.setUpViews()
    }
    
    func configure(post: PostModel) {
        currentPost = post
        nameLabel.text = post.author.name
        timeLabel.text = formattedTime(from: post.createdAt)
    }
    
    private func formattedTime(from date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        _ = calendar.dateComponents([.year, .day], from: date, to: now)
        let secondsAgo = Int(now.timeIntervalSince(date))
        
        if secondsAgo < 60 {
            return "Vừa xong"
        } else if secondsAgo < 3600 {
            return "\(secondsAgo / 60) phút trước"
        } else if secondsAgo < 86400 {
            return "\(secondsAgo / 3600) giờ trước"
        } else if secondsAgo < 604800 {
            return "\(secondsAgo / 86400) ngày trước"
        } else {
            let formatter = DateFormatter()
            if calendar.isDate(date, equalTo: now, toGranularity: .year) {
                formatter.dateFormat = "dd/MM"
            } else {
                formatter.dateFormat = "dd/MM/yyyy"
            }
            return formatter.string(from: date)
        }
    }
    
    func setHiddenMoreButton(_ hidden: Bool) {
        moreButton.isHidden = hidden
    }
    
    @IBAction func onPressMoreAction(_ sender: Any) {
        guard let currentPost = currentPost else { return }
        delegate?.postHeaderViewDidTapMore(self, post: currentPost)
    }
}
