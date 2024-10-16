//
//  ProfileViewMock.swift
//  ImageFeed
//
//  Created by Nurbol on 15.10.2024.
//

import Foundation
import ImageFeed

final class ProfileViewMock: ProfileViewProtocol {
    var updatedName: String?
    var updatedLogin: String?
    var updatedBio: String?
    var avatarURL: URL?
    var isLogoutConfirmationShown = false
    
    func updateProfileDetails(name: String?, login: String?, bio: String?) {
        updatedName = name
        updatedLogin = login
        updatedBio = bio
    }
    
    func updateAvatar(with url: URL?) {
        avatarURL = url
    }
    
    func showLogoutConfirmation() {
        isLogoutConfirmationShown = true
    }
}
