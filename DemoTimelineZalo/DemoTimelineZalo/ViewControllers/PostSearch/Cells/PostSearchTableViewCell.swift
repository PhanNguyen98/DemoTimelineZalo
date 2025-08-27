//
//  PostSearchTableViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 27/8/25.
//

import UIKit

class PostSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: AvatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(post: PostModel, searchText: String) {
        userNameLabel.text = post.author.name
        createAtLabel.text = post.createdAt.formattedString(format: "dd/MM")

        let content = post.content
        var displayText = content

        if !searchText.isEmpty,
           let range = content.lowercased().range(of: searchText.lowercased()) {
            _ = NSRange(range, in: content)
            let start = max(content.distance(from: content.startIndex, to: range.lowerBound) - 50, 0)
            let end = min(content.distance(from: content.startIndex, to: range.upperBound) + 50, content.count)
            let substringRange = content.index(content.startIndex, offsetBy: start)..<content.index(content.startIndex, offsetBy: end)
            displayText = String(content[substringRange])
            
            let attributedText = NSMutableAttributedString(string: displayText)
            if let highlightRange = displayText.lowercased().range(of: searchText.lowercased()) {
                let nsHighlightRange = NSRange(highlightRange, in: displayText)
                attributedText.addAttribute(.foregroundColor, value: UIColor.color4B85FB, range: nsHighlightRange)
            }
            contentLabel.attributedText = attributedText
        } else {
            contentLabel.text = content
        }

        contentLabel.numberOfLines = 3
    }
}
