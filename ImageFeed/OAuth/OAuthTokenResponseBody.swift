//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Nurbol on 28.08.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken, tokenType, scope: String
    let createdAt: Int
}
