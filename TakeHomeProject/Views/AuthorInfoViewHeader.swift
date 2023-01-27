//
//  AuthorInfoViewHeader.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import UIKit

class AuthorInfoViewHeader: UICollectionReusableView {
    
    static let identifier = "AuthorInfoViewHeader"

    let usernameTitle = UILabel()
    let usernameValue = UILabel()
    let fullNameTitle = UILabel()
    let fullNameValue = UILabel()
    let emailTitle = UILabel()
    let emailValue = UILabel()
    let phoneTitle = UILabel()
    let phoneValue = UILabel()
    let websiteTitle = UILabel()
    let websiteValue = UILabel()
    let companyTitle = UILabel()
    let companyValue = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithModel(model: AuthorInfoViewModel) {
        usernameValue.text = model.author.username
        fullNameValue.text = model.author.name
        emailValue.text = model.author.email
        phoneValue.text = model.author.phone
        websiteValue.text = model.author.website
        companyValue.text = model.author.company.companyName
    }
    
    func setupStack() {
        
    }
    
    private func setupUI() {
        usernameTitle.text = NSLocalizedString("Username:", comment: "Username")
        fullNameTitle.text = NSLocalizedString("FullName:", comment: "Full Name")
        emailTitle.text = NSLocalizedString("Email:", comment: "Email")
        phoneTitle.text = NSLocalizedString("Phone:", comment: "Phone")
        websiteTitle.text = NSLocalizedString("Website:", comment: "Website")
        companyTitle.text = NSLocalizedString("Company:", comment: "Company")
        
        let userNameStack = UIStackView(arrangedSubviews: [usernameTitle, usernameValue])
        userNameStack.setupForAuthorHeader()
        
        let fullNameStack = UIStackView(arrangedSubviews: [fullNameTitle, fullNameValue])
        fullNameStack.setupForAuthorHeader()

        let emailStack = UIStackView(arrangedSubviews: [emailTitle, emailValue])
        emailStack.setupForAuthorHeader()

        let phoneStack = UIStackView(arrangedSubviews: [phoneTitle, phoneValue])
        phoneStack.setupForAuthorHeader()
        
        let websiteStack = UIStackView(arrangedSubviews: [websiteTitle, websiteValue])
        websiteStack.setupForAuthorHeader()

        let companyStack = UIStackView(arrangedSubviews: [companyTitle, companyValue])
        companyStack.setupForAuthorHeader()
        
        let stackView = UIStackView(arrangedSubviews: [
            userNameStack,
            fullNameStack,
            emailStack,
            phoneStack,
            websiteStack,
            companyStack
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        self.addSubview(stackView)
        
        stackView.frame = bounds
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
