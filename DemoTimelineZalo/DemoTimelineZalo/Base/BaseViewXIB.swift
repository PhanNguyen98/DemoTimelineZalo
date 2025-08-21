//
//  BaseViewXIB.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class BaseViewXIB: UIView {

    private(set) var contentView: UIView!

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Setup

    private func commonInit() {
        loadFromNib()
        configureContentView()
        setUpViews()
    }

    private func loadFromNib() {
        let className = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))

        guard let view = bundle.loadNibNamed(className, owner: self, options: nil)?.first as? UIView else {
            fatalError("Failed to load nib named \(className)")
        }

        contentView = view
    }

    private func configureContentView() {
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    func setUpViews() {}
}

