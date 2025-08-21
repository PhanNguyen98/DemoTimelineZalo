//
//  BaseViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class BaseViewController: UIViewController {


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    deinit {
        removeKeyboardObservers()
    }

    // MARK: - Keyboard handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        
    }
}

