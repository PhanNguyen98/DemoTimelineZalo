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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAllPost()
        setupTableView()
    }
    
    func getAllPost() {
        dataPosts = postRepository.fetchAllPosts()
    }
    
    func setupUI() {
        searchTextField.becomeFirstResponder()
        searchTextField.autocorrectionType = .no
        searchTextField.spellCheckingType = .no
        searchTextField.delegate = self
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostSearchTableViewCell.self, bundle: .main)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
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
        searchText = updatedText
        if updatedText.isEmpty {
            dataSearch = []
        } else {
            dataSearch = dataPosts.filter { $0.content.lowercased().contains(updatedText.lowercased()) }
        }
        tableView.reloadData()
        return true
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
