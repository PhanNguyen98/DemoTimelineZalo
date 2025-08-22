//
//  PostListViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class PostListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreatePostTableViewCell.self, bundle: .main)
        tableView.register(PostTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    @IBAction func onPressCreatePost(_ sender: Any) {
    }
    
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: -UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch PostListSection.allCases[section] {
        case .createPost:
            return 1
        case .postList:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        //let row = indexPath.row
        switch PostListSection.allCases[section] {
        case .createPost:
            let cell: CreatePostTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .postList:
            let cell: PostTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure()
            return cell
        }
    }
}
