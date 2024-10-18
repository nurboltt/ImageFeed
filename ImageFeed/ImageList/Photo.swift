//
//  Photo.swift
//  ImageFeed
//
//  Created by Nurbol on 30.09.2024.
//

import Foundation

public struct Photo: Decodable {
    public let id: String
    public let size: CGSize
    public let createdAt: String?
    public let welcomeDescription: String?
    public let thumbImageURL: String
    public let largeImageURL: String
    public var isLiked: Bool
    
    public init(id: String, size: CGSize, createdAt: String?, welcomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}

extension Photo {
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = photoResult.size
        self.createdAt = photoResult.createdAt
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.regular
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.isLiked ?? false
    }
}
