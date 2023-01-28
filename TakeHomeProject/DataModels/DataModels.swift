//
//  DataModels.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import Foundation

/// Data model for retrieving a post from the API.
struct Post: Decodable {
    let userId: Int
    let postId: Int
    let postTitle: String
    let postBody: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case postId = "id"
        case postTitle = "title"
        case postBody = "body"
    }
}

/// Data model for a post's comment
struct Comment: Decodable {
    let postId: Int
    let commentId: Int
    let commentName: String
    let commentEmail: String
    let commentBody: String
    
    enum CodingKeys: String, CodingKey {
        case postId
        case commentId = "id"
        case commentName = "name"
        case commentEmail = "email"
        case commentBody = "body"
    }
}

/// Data model for the author of the post
struct Author: Decodable {
    let authorId: Int
    let name: String
    let username: String
    let address: Address
    let email: String
    let phone: String
    let website: String
    let company: Company
    
    enum CodingKeys: String, CodingKey {
        case authorId = "id"
        case name
        case username
        case email
        case address
        case phone
        case website
        case company
    }
}

/// Data model for an address
struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let coordinates: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipcode
        case coordinates = "geo"
    }
}

/// Data model for a coordinate
struct Coordinate: Decodable {
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

/// Data model for a company in which an author is associated.
struct Company: Decodable {
    let companyName: String
    let catchPhrase: String
    let businessDescription: String
    
    enum CodingKeys: String, CodingKey {
        case businessDescription = "bs"
        case catchPhrase
        case companyName = "name"
    }
}

/// Data model for a photo
struct Photo: Decodable {
    let albumId: Int
    let photoId: Int
    let photoTitle: String
    let photoUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case albumId
        case photoId = "id"
        case photoTitle = "title"
        case photoUrl = "url"
        case thumbnailUrl
    }
}

/// Data model for an album of photos
struct Album: Decodable {
    let userId: Int
    let albumId: Int
    let albumTitle: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case albumId = "id"
        case albumTitle = "title"
    }
}
