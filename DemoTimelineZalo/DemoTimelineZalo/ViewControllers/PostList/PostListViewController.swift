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
    
    var dataPosts: [PostModel] = []
    let postRepository = PostRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataPost()
        setupTableView()
        setupNotification()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.reloadData()
    }
    
    @objc func getDataPost() {
        dataPosts = postRepository.fetchAllPosts()
        tableView.reloadData()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getDataPost), name: .reloadDataPost, object: nil)
    }
    
    func setupUI() {
        searchView.addTapGesture(target: self, action: #selector(self.didTapSearch))
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreatePostTableViewCell.self, bundle: .main)
        tableView.register(UserPostTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    @objc func didTapSearch() {
        AppRouter.presentSearchViewController(from: self)
    }
    
    @IBAction func onPressCreatePost(_ sender: Any) {
        AppRouter.presentCreatePostVC(from: self)
    }
    
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch PostListSection.allCases[indexPath.section] {
        case .createPost:
            AppRouter.presentCreatePostVC(from: self)
        case .postList:
            AppRouter.pushtoPostDetail(from: self, post: dataPosts[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch PostListSection.allCases[section] {
        case .createPost:
            break
        case .postList:
            if let postCell = cell as? UserPostTableViewCell {
                postCell.configureWillDisplay(post: dataPosts[row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch PostListSection.allCases[section] {
        case .createPost:
            break
        case .postList:
            if let postCell = cell as? UserPostTableViewCell {
                postCell.configureEndDisplay(post: dataPosts[row])
            }
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
            return dataPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch PostListSection.allCases[section] {
        case .createPost:
            let cell: CreatePostTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .postList:
            let cell: UserPostTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureHeader(post: dataPosts[row], delegate: self)
            cell.configure(post: dataPosts[row], imageDelegate: self, videoDelegate: self)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: CreatePostTableViewCellDelegate
extension PostListViewController: CreatePostTableViewCellDelegate {
    func createPostCell(_ cell: CreatePostTableViewCell, didSelect media: PostMedia) {
        switch media {
        case .image:
            AppRouter.presentCreatePostVC(from: self, entryMode: .imagePicker)
        case .video:
            AppRouter.presentCreatePostVC(from: self, entryMode: .videoPicker)
        }
    }
}

// MARK: PostHeaderViewDelegate
extension PostListViewController: PostHeaderViewDelegate {
    func postHeaderViewDidTapMore(_ headerView: PostHeaderView, post: PostModel) {
        AppRouter.presentOptionsMenu(from: self, post: post)
    }
}

// MARK: ImagePostContentViewDelegate
extension PostListViewController: ImagePostContentViewDelegate {
    func imagePostContentView(_ view: ImagePostContentView, didSelectImageAt index: Int, image: ImageModel, post: PostModel ) {
    }
}

// MARK: VideoPostContentViewDelegate
extension PostListViewController: VideoPostContentViewDelegate {
    func videoPostContentViewDidTap(_ view: VideoPostContentView, video: VideoModel) {
        tableView.reloadData()
        AppRouter.presentVideoViewer(from: self, video: video)
    }
}

// MARK: UserPostTableViewCellDelegate
extension PostListViewController: UserPostTableViewCellDelegate {
    func didTapContent(in cell: UserPostTableViewCell, post: PostModel) {
        AppRouter.pushtoPostDetail(from: self, post: post)
    }
}
