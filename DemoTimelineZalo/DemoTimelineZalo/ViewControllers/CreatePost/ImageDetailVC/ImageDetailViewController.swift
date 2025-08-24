//
//  ImageDetailViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 24/8/25.
//

import UIKit

class ImageDetailViewController: BaseViewController {
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            contentImageView.image = image
        }
    }
    
    @IBAction func onPressDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
