//
//  SwiftUIView.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/27/23.
//

import SwiftUI

/// SwiftUI View for the Author Header information
struct SwiftUIHeaderSection: View {
    var author: Author?
    
    var body: some View {
        if let author = author {
            VStack (
                alignment: .leading,
                spacing: 10
            ) {
                VStack (
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(verbatim: "Username123:")
                    Text(verbatim: "\(author.username)")
                }
                VStack (
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(verbatim: "Full Name:")
                    Text(verbatim: "\(author.name)")
                }
                VStack (
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(verbatim: "Email:")
                    Text(verbatim: "\(author.email)")
                }
                VStack (
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(verbatim: "Phone:")
                    Text(verbatim: "\(author.phone)")
                }
                VStack (
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(verbatim: "Website:")
                    Text(verbatim: "\(author.website)")
                }
                VStack (
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(verbatim: "Company:")
                    Text(verbatim: "\(author.company.companyName)")
                }
            }.padding(.leading)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIHeaderSection(author: .init(authorId: 1,
                                           name: "Bill Higgins",
                                           username: "Bhigs",
                                           address: .init(street: "",
                                                          suite: "",
                                                          city: "",
                                                          zipcode: "",
                                                          coordinates: .init(latitude: "12", longitude: "12")),
                                           email: "bill@bill.com",
                                           phone: "123-456-7890",
                                           website: "billhiggins.com",
                                           company: .init(companyName: "Bill's Store",
                                                          catchPhrase: "Yes",
                                                          businessDescription: "Tools")))
    }
}
