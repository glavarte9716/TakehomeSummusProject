//
//  AuthorPhotoCollectionViewCell.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit

/// View model for each photo cell in the list of author's photo.
struct AuthorPhotoCollectionCellViewModel {
    let photo: Photo
}

/// Collection view cell for an author's photo to be shown..
class AuthorPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "PhotoCollectionViewCell"
    private let myImageView = UIImageView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Function sets up the UI.
    private func setupUI() {
        contentView.addSubview(myImageView)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
    }
    
    /// Configuration function that loads up the cell's image.
    /// - Parameter model: View model that contains the photo data.
    func configurePhotoCell(model: AuthorPhotoCollectionCellViewModel) {
        setImage(from: model.photo.photoUrl)
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.myImageView.image = image
            }
        }
    }
}
