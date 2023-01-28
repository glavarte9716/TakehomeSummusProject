//
//  AuthorsViewController.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit
import SwiftUI
import Combine

/// View Model for populating the `AuthorInfoViewController`.
struct AuthorInfoViewModel {
    let photos: [Photo]
    let author: Author
}

/// View controller responsible for the post author's information.
class AuthorInfoViewController: UIViewController {

    // MARK: - Properties
    // Signal used to pass information from the upstream service.
    var viewModel: AuthorInfoViewModel?
    var authorInfoPageManager: AuthorInfoPageManager = AuthorInfoPageManager(authorViewControllerSignal: .init(nil))
    var observations = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private var collectionView: UICollectionView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscription()
        
        if let id = authorInfoPageManager.authorViewControllerSignal.value?.author.authorId {
            authorInfoPageManager.fetchPhotosForAuthorId(id: String(id))
        }
        
        setupUI()
    }
    
    // MARK: - Instance Methods
    /// Sets up the subscription for the current value subject that receives the upstream data.
    func setupSubscription() {
        observations.removeAll()
        
        authorInfoPageManager.authorViewControllerSignal.sink(receiveValue: { [weak self] model in
            guard let self = self, let model = model else { return }
            self.configureWithModel(model: model)
        }).store(in: &observations)
    }
    
    /// Configure the screen with the view model.
    /// - Parameter model: Model for filling out the '`AuthorInfoViewController`.
    func configureWithModel(model: AuthorInfoViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel = model
            self.collectionView?.reloadData()
        }
    }
    
    /// Helper for performing all the UI layout.
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.width/2) - 4,
                                 height: (view.frame.width/2) - 4)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        layout.headerReferenceSize = .init(width: view.bounds.width, height: 300)
        collectionView.register(AuthorPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AuthorPhotoCollectionViewCell.identifier)
        collectionView.register(AuthorInfoViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: AuthorInfoViewHeader.identifier)
        

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
    }
    
}

// MARK: - CollectionView Data Source and Delegate
extension AuthorInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthorPhotoCollectionViewCell.identifier, for: indexPath) as?
                AuthorPhotoCollectionViewCell ,
              let photo = viewModel?.photos[safe: indexPath.row] else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.configurePhotoCell(model: .init(photo: photo))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: AuthorInfoViewHeader.identifier,
                                                                               for: indexPath) as? AuthorInfoViewHeader else {
            return UICollectionReusableView()
        }
        let hostingController = UIHostingController(rootView: SwiftUIHeaderSection(author: viewModel?.author))
        addChild(hostingController)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: headerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -150),
        ])
        return headerView
    }
}
