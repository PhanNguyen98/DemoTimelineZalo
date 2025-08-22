//
//  PostImageCollectionViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberImageLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overlayView.isHidden = true
        backgroundColor = .black.withAlphaComponent(0.2)
    }

    func configure(urlString: String, numberImage: Int, index: Int) {
        
    }
}
