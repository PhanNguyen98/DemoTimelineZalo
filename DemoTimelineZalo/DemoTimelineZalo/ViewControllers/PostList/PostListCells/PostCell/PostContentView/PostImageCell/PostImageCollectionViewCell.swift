//
//  PostImageCollectionViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var numberImageLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    
    var onDeleteTapped: (() -> Void) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.isHidden = true
        overlayView.isHidden = true
        backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    func configureSelected(image: UIImage, index: Int, totalImages: Int) {
        postImageView.image = image
        deleteButton.isHidden = false
        let shouldShowOverlay = (index + 1 == 5) && (totalImages > 5)
        overlayView.isHidden = !shouldShowOverlay
        numberImageLabel.text = shouldShowOverlay ? "+\(totalImages - 5)" : nil
    }
    
    @IBAction func onPressDelete(_ sender: Any) {
        onDeleteTapped()
    }
    
}
