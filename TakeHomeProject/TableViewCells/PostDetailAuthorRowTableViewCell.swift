//
//  PostDetailAuthorRowTableViewCell.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit

struct PostDetailAuthorRowTableViewCellModel {
    let author: Author
}

class PostDetailAuthorRowTableViewCell: UITableViewCell {
    static let identifier = "PostDetailAuthorRowTableViewCell"
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Elements
    let authorNameLabel = UILabel()
    let selectRowLabel = UILabel()
    let profileImage = UIImageView()
    let topLevelStack = UIStackView()
    
    // MARK: - Instance Methods
    func setupCellLayout() {
        authorNameLabel.numberOfLines = 0
        selectRowLabel.numberOfLines = 0
        selectRowLabel.textAlignment = .right
        let stackView = UIStackView(arrangedSubviews: [profileImage, authorNameLabel, selectRowLabel])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        self.contentView.addSubview(stackView)
        
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        selectRowLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        topLevelStack.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileImage.heightAnchor.constraint(equalToConstant: 24),
            profileImage.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        selectRowLabel.text = NSLocalizedString("View authors profile", comment: "Authors Name")
        let image = UIImage(named: "profile_img")
        profileImage.image = image
    }
    
    func configureWithModel(model: PostDetailAuthorRowTableViewCellModel) {
        authorNameLabel.text = model.author.name
    }
}
