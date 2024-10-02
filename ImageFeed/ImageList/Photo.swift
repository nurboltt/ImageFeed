//
//  Photo.swift
//  ImageFeed
//
//  Created by Nurbol on 30.09.2024.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
