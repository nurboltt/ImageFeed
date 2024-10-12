//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nurbol on 23.09.2024.
//

import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    static let shared = ProfileImageService()
    private let storage: UserDefaults = .standard
    private init() { }
    var avatarURL: String? {
        get {
            storage.string(forKey: "avatarURL")
        }
        set {
            storage.setValue(newValue, forKey: "avatarURL")
        }
    }
    
    func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "/users/\(username)") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = tokenStorage.bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.avatarURL = profile.profileImage.large
                completion(.success(self.avatarURL ?? ""))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profile.profileImage.large]
                )
            case .failure(let error):
                print("Access token decode error : \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func clearProfileImage() {
        avatarURL = nil
        task = nil
    }
}
