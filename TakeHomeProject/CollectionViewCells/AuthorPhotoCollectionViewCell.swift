//
//  AuthorPhotoCollectionViewCell.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit

struct AuthorPhotoCollectionCellViewModel {
    let photo: Photo
}

class AuthorPhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    private let myImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
