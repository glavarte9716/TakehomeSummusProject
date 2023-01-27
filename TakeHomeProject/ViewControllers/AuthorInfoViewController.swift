//
//  AuthorsViewController.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit
import Combine

struct AuthorInfoViewModel {
    let photos: [Photo]
    let author: Author
}

class AuthorInfoViewController: UIViewController {
    // MARK: - Properties
    let authorsViewControllerSignal = CurrentValueSubject<AuthorInfoViewModel?, Never>.init(nil)
    var viewModel: AuthorInfoViewModel?
    var authorInfoPageManager: AuthorInfoPageManager?
    var observations = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorInfoPageManager = AuthorInfoPageManager(authorViewControllerSignal: authorsViewControllerSignal)
        setupSubscription()
        if let id = authorsViewControllerSignal.value?.author.authorId {
            authorInfoPageManager?.fetchPhotosForAuthorId(id: String(id))
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.width/2) - 4,
                                 height: (view.frame.width/2) - 4)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        layout.headerReferenceSize = .init(width: view.bounds.width, height: 285)
        collectionView.register(AuthorPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AuthorPhotoCollectionViewCell.identifier)
        collectionView.register(AuthorInfoViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: AuthorInfoViewHeader.identifier)
        

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
    }
    
    func setupSubscription() {
        observations.removeAll()
        
        authorsViewControllerSignal.sink(receiveValue: { [weak self] model in
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

    
}

extension AuthorInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthorPhotoCollectionViewCell.identifier, for: indexPath) as?
                AuthorPhotoCollectionViewCell ,
              let photo = viewModel?.photos[safe: indexPath.row] else {
            let cell = UICollectionViewCell()
            cell.backgroundColor = .systemBlue
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
        if let viewModel = self.viewModel {
            headerView.configureWithModel(model: viewModel)
        }
        return headerView
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        // Get the view for the first header
//        let indexPath = IndexPath(row: 0, section: section)
//        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.widthAnchor.constraint(equalToConstant: collectionView.frame.width).isActive = true
//        return headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
////            // Use this view to calculate the optimal size based on the collection view's width
////            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
////                                                      withHorizontalFittingPriority: .required, // Width is fixed
////                                                      verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
//    }
}
