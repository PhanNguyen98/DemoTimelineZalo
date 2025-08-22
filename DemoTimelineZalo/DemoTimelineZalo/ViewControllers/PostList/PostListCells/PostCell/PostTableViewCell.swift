//
//  PostTableViewCell.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorF3F5F6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let headerView: PostHeaderView = {
        let view = PostHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentViewCustom: PostContentView = {
        let view = PostContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [lineView, headerView, contentViewCustom])
        stack.axis = .vertical
        stack.spacing = 8
        contentView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 5),
            
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
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
        headerView.configure()
        headerView.backgroundColor = .red
        contentViewCustom.configure()
    }
}
