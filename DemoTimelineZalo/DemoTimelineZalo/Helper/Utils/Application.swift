//
//  Application.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class Application {
    static let shared = Application()
    private var window: UIWindow?
    
    func goToSplashScreen(window: UIWindow?) {
        let nagivationController = UINavigationController(rootViewController: SplashViewController())
        self.window = window
        guard let window = window else { return }
        window.rootViewController = nagivationController
        window.makeKeyAndVisible()
    }
    
    func goToPostListScreen() {
        guard let window = window else { return }
        let viewcontroller = PostListViewController.instantiate(from: .postList)
        let navigationController = UINavigationController(rootViewController: viewcontroller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .curveEaseIn, animations: nil)
    }
}
