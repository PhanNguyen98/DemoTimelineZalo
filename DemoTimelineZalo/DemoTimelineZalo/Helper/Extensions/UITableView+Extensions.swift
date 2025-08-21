//
//  UITableView+Extensions.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit


extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type, bundle: Bundle? = nil) {
        let identifier = String(describing: cellType)
        if let bundle = bundle {
            let nib = UINib(nibName: identifier, bundle: bundle)
            register(nib, forCellReuseIdentifier: identifier)
        } else {
            register(cellType, forCellReuseIdentifier: identifier)
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("⚠️ Could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
