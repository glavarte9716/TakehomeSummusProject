//
//  PostCellView.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import Foundation
import UIKit

/// View model for configuring a PostCellViewModel
struct PostCellViewModel {
    let title: String
    let body: String
    let author: String
    let imageDestination: String
}

class PostCellView: UITableViewCell {
    static let identifier = "postCell"

    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let profileImage = UIImageView()
    let authorNameLabel = UILabel()
    let subStackView = UIStackView()
    let topLevelStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the table view cell containing the post information
    /// - Parameter model: model used to configure the cell
    func configureWithModel(model: PostCellViewModel) {
        titleLabel.text = model.title
        bodyLabel.text = model.body
        authorNameLabel.text = model.author
        let image = UIImage(named: "profile_img")
        profileImage.image = image
    }

    /// Function will programmatically build out the cell.
    func setupCellLayout() {
        self.contentView.addSubview(topLevelStack)
        self.accessoryType = .disclosureIndicator
        bodyLabel.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        authorNameLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        authorNameLabel.numberOfLines = 0
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        topLevelStack.translatesAutoresizingMaskIntoConstraints = false
        subStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topLevelStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topLevelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topLevelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topLevelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            profileImage.heightAnchor.constraint(equalToConstant: 24),
            profileImage.widthAnchor.constraint(equalToConstant: 24)
        ])

        subStackView.addArrangedSubview(profileImage)
        subStackView.addArrangedSubview(authorNameLabel)
        subStackView.axis = .horizontal
        subStackView.alignment = .fill
        subStackView.spacing = CGFloat(12)
        
        topLevelStack.axis = .vertical
        topLevelStack.alignment = .fill
        topLevelStack.addArrangedSubview(subStackView)
        topLevelStack.addArrangedSubview(titleLabel)
        topLevelStack.addArrangedSubview(bodyLabel)
        topLevelStack.spacing = CGFloat(12)
    }
}
