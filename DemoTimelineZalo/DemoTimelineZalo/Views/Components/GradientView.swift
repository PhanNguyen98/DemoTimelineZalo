//
//  GradientView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    // MARK: - Properties
    @IBInspectable var startColor: UIColor = .blue {
        didSet { updateColors() }
    }
    
    @IBInspectable var endColor: UIColor = .purple {
        didSet { updateColors() }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet { updatePoints() }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 0.5) {
        didSet { updatePoints() }
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    // MARK: - Overrides
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: - Update methods
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    private func updatePoints() {
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
