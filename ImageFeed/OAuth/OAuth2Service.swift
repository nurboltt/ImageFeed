//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nurbol on 28.08.2024.
//

import UIKit

private protocol OAuth2ServiceProtocol {
    func makeOAuthTokenRequest(code: String) -> URLRequest
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void)
}

final class OAuth2Service: OAuth2ServiceProtocol {
    
    static let shared = OAuth2Service()
    private init() { }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            fatalError("Invalid baseUrl")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            fatalError("Invaild url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: request) { result in
            
            switch result {
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = token.accessToken
                    completion(.success(accessToken))
                } catch {
                    print("Access token decode error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Network error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
