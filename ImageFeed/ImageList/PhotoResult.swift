//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nurbol on 01.10.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width, height: Int
    let createdAt: String
    let description: String?
    let urls: PhotoURLs
    let isLiked: Bool?
    
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}

struct PhotoURLs: Decodable {
    let raw, full, regular, small, thumb: String
}

struct LikeResponse: Decodable {
    let photo: PhotoResult
}
