//
//  UserPostTableViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class UserPostTableViewCell: BasePostTableViewCell {
    
    private let headerView: PostHeaderView = {
        let view = PostHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageContentView: ImagePostContentView = {
        let view = ImagePostContentView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let videoContentView: VideoPostContentView = {
        let view = VideoPostContentView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        imageContentView.isHidden = false
        imageContentView.configure()
    }
}
