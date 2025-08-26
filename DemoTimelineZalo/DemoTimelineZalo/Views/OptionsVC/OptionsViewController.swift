//
//  OptionsViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 26/8/25.
//

import UIKit
import PanModal

class OptionsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var post: PostModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OptionTableViewCell.self, bundle: .main)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - UITableView Delegate & DataSource
extension OptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OptionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell: OptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(option: OptionType.allCases[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch OptionType.allCases[indexPath.row] {
        case .deletePost:
            guard let post = self.post else { return }
            Task {
                if PostManager(postRepo: PostRepository()).deletePost(post: post) {
                    NotificationCenter.default.post(name: .reloadDataPost, object: nil)
                    dismiss(animated: true)
                }
            }
        }
    }
}

extension OptionsViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(CGFloat(OptionType.allCases.count * 50) + 20)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    var cornerRadius: CGFloat {
        return 20
    }
    
    var allowsDragToDismiss: Bool {
        return true
    }
}
