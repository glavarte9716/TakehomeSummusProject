//
//  PhotoDataModel.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import Foundation

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


