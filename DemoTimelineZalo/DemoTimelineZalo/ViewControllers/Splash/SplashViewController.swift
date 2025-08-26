//
//  SplashViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        gotoPostList()
        UserManager.shared.loadUser()
    }

    func gotoPostList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            Application.shared.goToPostListScreen()
        })
    }
}
