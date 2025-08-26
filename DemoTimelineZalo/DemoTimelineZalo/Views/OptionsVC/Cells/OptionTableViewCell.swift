//
//  OptionTableViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 26/8/25.
//

import UIKit

class OptionTableViewCell: UITableViewCell {
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(option: OptionType) {
        iconImageView.image = option.icon
        titleLabel.text = option.title
        subTitleLabel.text = option.subTitle
    }
}
