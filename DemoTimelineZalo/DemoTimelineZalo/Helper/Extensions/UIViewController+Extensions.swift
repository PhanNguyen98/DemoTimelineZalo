//
//  UIViewController+Extensions.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

extension UIViewController {
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    static func instantiate(from storyboardName: StoryboardName, storyboardID: String? = nil) -> Self {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle.main)
        let id = storyboardID ?? String(describing: self)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: id) as? Self else {
            fatalError("Cannot instantiate \(self) from storyboard \(storyboardName)")
        }
        return vc
    }
}
