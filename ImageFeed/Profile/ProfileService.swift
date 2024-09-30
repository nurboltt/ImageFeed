//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nurbol on 14.09.2024.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

enum ProfileServiceError: Error {
    case invalidToken
    case invalidRequest
}

final class ProfileService: ProfileServiceProtocol  {
    
    private let tokenStorage = OAuth2TokenStorage()
    
    static let shared = ProfileService()
    private init() { }
    
    private var task: URLSessionTask?
    private let storage: UserDefaults = .standard
    
    var profile: Profile? {
        get {
            guard let data = storage.data(forKey: "profile") else { return nil }
            return try? JSONDecoder().decode(Profile.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            storage.set(data, forKey: "profile")
        }
    }
    
    
    func makeProfileServiceRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(completion: @escaping (Result<Profile,Error>) -> Void) {
        
        guard let token = tokenStorage.bearerToken else {
            completion(.failure(ProfileServiceError.invalidToken))
            return
        }
        
        task?.cancel()
        
        guard let request = makeProfileServiceRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<Profile,Error>) in
            guard let self else { return}
            switch result {
            case .success(let profile):
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("Error decoding: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
      
        self.task = task
        task.resume()
    }
}

