//
//  ViewController.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import UIKit
import Combine

/// View Model for the Home Screen.
struct HomeViewModel {
    let posts: [Post]
    let authors: [Author]
    
    /// Fetches the author name from the authors list using the authorId
    /// - Parameter authorId: Author distinct Id number
    func getAuthorFromId(authorId: Int) -> Author? {
        if let author = authors.first(where: { $0.authorId == authorId }) {
            return author
        }
        return nil
    }
}

/// Main initial view controller that loads the table of posts.
class HomeViewController: UIViewController {

    // MARK: - Properties
    // Signal used to pass information from the upstream service.
    let homeViewControllerSignal = CurrentValueSubject<HomeViewModel, Never>.init(.init(posts: [], authors: []))
    var homePageManager: HomePageManager?
    var viewModel: HomeViewModel?
    var observations = Set<AnyCancellable>()

    // MARK: - UIComponents
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.register(PostCellView.self, forCellReuseIdentifier: PostCellView.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        homePageManager = HomePageManager(homeViewControllerSignal: homeViewControllerSignal)
        setupSubscription()
        homePageManager?.fetchHomePageData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Instance Methods
    /// Initiate function that sets up the UI for the TableView.
    func setupUI() {
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("Takehome", comment: "Name of the project")
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12)
        ])
    }
    
    /// Sets up the subscription for the current value subject that receives the upstream data.
    func setupSubscription() {
        observations.removeAll()
        homeViewControllerSignal.dropFirst().sink(receiveValue: { [weak self] viewModel in
            guard let self = self,
                  !viewModel.authors.isEmpty,
                  !viewModel.posts.isEmpty else { return }
            self.configureWithModel(model: viewModel)
        }).store(in: &observations)
    }

    /// Configuration function that reloads the screen when new data is present.
    /// - Parameter model: ViewModel with the post data.
    func configureWithModel(model: HomeViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel = model
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView Data Source and Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let post = viewModel.posts[safe: indexPath.row],
              let author = viewModel.getAuthorFromId(authorId: post.userId),
              let tableViewCell = tableView.dequeueReusableCell(withIdentifier: PostCellView.identifier,
                                                                for: indexPath) as? PostCellView else {
            return UITableViewCell()
        }
        
        let cellViewModel = PostCellViewModel(title: post.postTitle, body: post.postBody, author: author.name, imageDestination: "")
        tableViewCell.configureWithModel(model: cellViewModel)
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
              let post = viewModel.posts[safe: indexPath.row],
              let author = viewModel.getAuthorFromId(authorId: post.userId) else {
            return
        }
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.detailViewSignal.send(.init(comments: [], post: post, author: author))
        navigationController?.pushViewController(postDetailViewController, animated: true)
    }
}
