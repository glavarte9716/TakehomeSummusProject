//
//  DetailViewController.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit
import Combine

/// View model for the `PostDetailViewController`.
struct PostDetailViewModel {
    let comments: [Comment]
    let post: Post
    let author: Author
}

/// View controller for the detail screen pushed on after selection a post.
class PostDetailViewController: UIViewController {
    // MARK: - Properties
    var detailPageManager: DetailPageManager = DetailPageManager(detailControllerSignal: .init(nil))
    private var viewModel: PostDetailViewModel?
    private var observations = Set<AnyCancellable>()
    
    // MARK: - UIComponents
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.register(PostDetailTableViewCell.self, forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        tableView.register(PostDetailAuthorRowTableViewCell.self, forCellReuseIdentifier: PostDetailAuthorRowTableViewCell.identifier)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscription()
        if let id = detailPageManager.detailControllerSignal.value?.post.postId {
            detailPageManager.fetchDetailPageData(id: String(id))
        }
        self.view.backgroundColor = .systemBlue
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.deselectSelectedRow(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Instance Methods
    private func setupSubscription() {
        observations.removeAll()
        detailPageManager.detailControllerSignal.dropFirst().sink(receiveValue: { [weak self] viewModel in
            guard let self = self,
                  let viewModel = viewModel,
                  !viewModel.comments.isEmpty else { return }
            self.configureWithModel(model: viewModel)
        }).store(in: &observations)
    }
    
    /// Sets up the UI elements for the Post Detail Screen
    private func setupUI() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
    
    /// Configure the screen with the view model
    /// - Parameter model: view model of the screen which should contain all the data for the list of comments, the author, as well as the post details.
    private func configureWithModel(model: PostDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel = model
            self.tableView.reloadData()
        }
    }   
}

// MARK: - TableView Data Source and Delegate
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.comments.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.identifier) as? PostDetailTableViewCell {
                cell.configureWithModel(model: .init(body: viewModel.post.postBody, title: viewModel.post.postTitle))
                cell.selectionStyle = .none
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailAuthorRowTableViewCell.identifier) as?
                PostDetailAuthorRowTableViewCell {
                cell.configureWithModel(model: .init(author: viewModel.author))
                cell.selectionStyle = .default
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell,
               let comment = viewModel.comments[safe: indexPath.row - 2] {
                cell.configureWithModel(model: .init(comment: comment))
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 1, let viewModel = viewModel else { return }
        let authorsViewController = AuthorInfoViewController()
        authorsViewController.authorInfoPageManager.authorViewControllerSignal.send(.init(photos: [], author: viewModel.author))
        navigationController?.pushViewController(authorsViewController, animated: true)
    }
}
