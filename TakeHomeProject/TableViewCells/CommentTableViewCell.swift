//
//  CommentTableViewCell.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit

/// View Model for the `CommentTableViewCell`.
struct CommentTableViewCellModel {
    let comment: Comment
}

/// Custom Cell type for displaying the `Comment` information.
class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Elements
    let titleLabel = UILabel()
    let emailLabel = UILabel()
    let commentBodyLabel = UILabel()
    let topLevelStack = UIStackView()
    
    // MARK: - Instance Methods
    
    /// Programmatically builds the UI for the cell.
    func setupCellLayout() {
        titleLabel.numberOfLines = 0
        emailLabel.numberOfLines = 1
        emailLabel.lineBreakMode = .byWordWrapping
        commentBodyLabel.numberOfLines = 0
        let stackView = UIStackView(arrangedSubviews: [titleLabel, emailLabel, commentBodyLabel])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        self.contentView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        commentBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        topLevelStack.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    /// Configures the cell with comment information.
    /// - Parameter model: Comment information.
    func configureWithModel(model: CommentTableViewCellModel) {
        titleLabel.text = model.comment.commentName
        emailLabel.text = model.comment.commentEmail
        commentBodyLabel.text = model.comment.commentBody
    }

}
