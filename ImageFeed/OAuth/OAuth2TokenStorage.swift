//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nurbol on 28.08.2024.
//
import Foundation

private protocol OAuth2TokenStorageProtocol {
    var bearerToken: String? { get }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private let storage: UserDefaults = .standard
    private enum Key: String {
        case bearerToken
    }
    
    var bearerToken: String? {
        get {
            storage.string(forKey: Key.bearerToken.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Key.bearerToken.rawValue)
        }
    }
}
