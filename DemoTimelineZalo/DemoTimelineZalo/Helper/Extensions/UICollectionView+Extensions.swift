//
//  UICollectionView+Extensions.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type, bundle: Bundle? = nil) {
        let identifier = String(describing: cellType)
        if let bundle = bundle {
            let nib = UINib(nibName: identifier, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: identifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: identifier)
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("⚠️ Could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
