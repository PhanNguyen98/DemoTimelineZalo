//
//  PostListViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class PostListViewController: BaseViewController {
    
    private enum PostListSection: Int, CaseIterable {
        case createPost = 0
        case postList
    }
    
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
        tableView.register(UserPostTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    private func presentCreatePostVC() {
        let createPostVC = CreatePostViewController.instantiate(from: .createPost)
        createPostVC.modalPresentationStyle = .overFullScreen
        present(createPostVC, animated: true)
    }
    
    @IBAction func onPressCreatePost(_ sender: Any) {
        presentCreatePostVC()
    }
    
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch PostListSection.allCases[indexPath.section] {
        case .createPost:
            presentCreatePostVC()
        case .postList:
            break
        }
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
            cell.delegate = self
            return cell
        case .postList:
            let cell: UserPostTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure()
            return cell
        }
    }
}

// MARK: CreatePostTableViewCellDelegate
extension PostListViewController: CreatePostTableViewCellDelegate {
    func createPostCell(_ cell: CreatePostTableViewCell, didSelect media: PostMedia) {
        switch media {
        case .image:
            presentCreatePostVC()
        case .video:
            presentCreatePostVC()
        }
    }
}
