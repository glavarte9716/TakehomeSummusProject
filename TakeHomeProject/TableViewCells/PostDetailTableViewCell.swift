//
//  PostDetailTableViewCell.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit

/// View Model for the Post Detail screens post cell.
struct PostDetailTableViewCellModel {
    let body: String
    let title: String
}

/// TableViewCell for the Post information on the Detail screen
class PostDetailTableViewCell: UITableViewCell {
    static let identifier = "PostDetailTableViewCell"
    
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
    let bodyLabel = UILabel()
    let topLevelStack = UIStackView()
    
    // MARK: - Instance Methods
    func setupCellLayout() {
        self.contentView.addSubview(topLevelStack)
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        bodyLabel.font = .preferredFont(forTextStyle: .body)
        
        topLevelStack.alignment = .fill
        topLevelStack.distribution = .fill
        topLevelStack.axis = .vertical
        
        topLevelStack.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLevelStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topLevelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            topLevelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topLevelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        topLevelStack.addArrangedSubview(titleLabel)
        topLevelStack.addArrangedSubview(bodyLabel)
    }
    
    func configureWithModel(model: PostDetailTableViewCellModel) {
        titleLabel.text = model.title
        bodyLabel.text = model.body
    }
}
