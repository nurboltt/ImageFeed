//
//  Profile.swift
//  ImageFeed
//
//  Created by Nurbol on 14.09.2024.
//

import Foundation

public struct Profile: Codable {
    public let username: String?
    public let name: String?
    public let loginName: String?
    public let bio: String?
    
   public init(username: String?, name: String?, loginName: String?, bio: String?) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}
