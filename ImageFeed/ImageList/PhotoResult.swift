//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nurbol on 01.10.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt, updatedAt: Date
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String
//    let user: User
//    let currentUserCollections: [CurrentUserCollection]
    let urls: Urls
//    let links: PhotoResultLinks

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
//        case currentUserCollections = "current_user_collections"
        case urls
    }
}

struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}
