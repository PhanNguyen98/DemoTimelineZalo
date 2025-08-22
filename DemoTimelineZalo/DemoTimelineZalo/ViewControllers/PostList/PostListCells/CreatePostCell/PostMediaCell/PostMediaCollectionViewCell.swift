//
//  PostMediaCollectionViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class PostMediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(media: PostMedia) {
        nameLabel.text = media.title
        iconImageView.image = media.icon
    }
}
