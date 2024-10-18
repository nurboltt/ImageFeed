//
//  ProfileServiceMock.swift
//  ImageFeed
//
//  Created by Nurbol on 15.10.2024.
//

import Foundation
import ImageFeed

final class ProfileServiceMock: ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<Profile, any Error>) -> Void) {
        
    }
    
    var profile: Profile?
}
