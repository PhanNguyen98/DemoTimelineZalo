//
//  UIView+Extensions.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity * 100 }
        set { layer.shadowOpacity = newValue / 100 }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    func addTapGesture(target: Any, action: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        gesture.cancelsTouchesInView = false
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }
}
