//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nurbol on 28.08.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let storage = KeychainWrapper.standard
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "bearerToken"
    private let appFirstRunKey = "appFirstRun"
    
    init() {
        if !userDefaults.bool(forKey: appFirstRunKey) {
            storage.removeObject(forKey: tokenKey)
            userDefaults.set(true, forKey: appFirstRunKey)
        }
    }
    
    var bearerToken: String? {
        get {
            storage.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                storage.set(token, forKey: tokenKey)
            } else {
                storage.removeObject(forKey: tokenKey)
            }
        }
    }
}
