//
//  PostSearchViewController.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

class PostSearchViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var dataPosts: [PostModel] = []
    var dataSearch: [PostModel] = []
    var searchText: String = ""
    
    let postRepository = PostRepository()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAllPost()
        setupTableView()
        setupNotification()
    }
    
    // MARK: - Data Handling
    func getAllPost() {
        dataPosts = postRepository.fetchAllPosts()
    }
    
    @objc func reloadData() {
        getAllPost()
        handleSearchTextChange(searchText)
    }
    
    // MARK: - Setup UI
    func setupUI() {
        searchTextField.becomeFirstResponder()
        searchTextField.autocorrectionType = .no
        searchTextField.spellCheckingType = .no
        searchTextField.delegate = self
    }
    
    // MARK: - Notification
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: .reloadDataPost, object: nil)
    }
    
    // MARK: - TableView Setup
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostSearchTableViewCell.self, bundle: .main)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    // MARK: - Actions
    @IBAction func onPressBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: UITextFieldDelegate
extension PostSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        handleSearchTextChange(updatedText)
        return true
    }
    
    func handleSearchTextChange(_ updatedText: String) {
        searchText = updatedText
        if updatedText.isEmpty {
            dataSearch = []
        } else {
            dataSearch = dataPosts.filter { $0.content.lowercased().contains(updatedText.lowercased()) }
        }
        tableView.reloadData()
    }
}

extension PostSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSearch.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostSearchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let post = dataSearch[indexPath.row]
        cell.configure(post: post, searchText: searchText)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = dataSearch[indexPath.row]
        AppRouter.pushtoPostDetail(from: self, post: post)
    }
}
