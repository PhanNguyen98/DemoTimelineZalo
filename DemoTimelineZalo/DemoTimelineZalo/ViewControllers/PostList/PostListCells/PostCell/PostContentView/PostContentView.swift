//
//  PostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class PostContentView: UIView {
    
    // MARK: - UI Components
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let mediaView: GradientView = {
        let view = GradientView()
        view.startColor = .color61ABF1
        view.endColor = .colorF3F5F6
        view.startPoint = .init(x: 0, y: 0)
        view.endPoint = .init(x: 1, y: 1)
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
    }
    
}
