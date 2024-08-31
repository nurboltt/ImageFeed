//
//  Constants.swift
//  ImageFeed
//
//  Created by Nurbol on 22.08.2024.
//

import Foundation

enum Constants {
    static let accessKey = "9xCpz5XD2fWl6ypWzuAcI77oy5QIigF8C1be8v7hSTA"
    static let secretKey = "n28M897QPGwuBAOmccP1cmvAH42T7dUUshxoyXBmkl8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Invalid URL")
        }
        return url
    }()
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
