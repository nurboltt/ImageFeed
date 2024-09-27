//
//  UserResult.swift
//  ImageFeed
//
//  Created by Nurbol on 23.09.2024.
//

import UIKit

struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small, medium, large: String
}
