//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Nurbol on 08.10.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() { }
    
    func logout() {
        clearAuthToken()
        cleanCookies()
        clearProfileData()
        clearProfileImage()
        clearImagesList()
        navigateToInitialScreen()
    }
    
    private func cleanCookies() {
        DispatchQueue.global(qos: .background).async {
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            
            DispatchQueue.main.async {
                let dataStore = WKWebsiteDataStore.default()
                dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    }
                }
            }
        }
    }
    
    private func clearProfileData() {
        ProfileService.shared.clearProfile()
    }
    
    private func clearProfileImage() {
        ProfileImageService.shared.clearProfileImage()
    }
    
    private func clearImagesList() {
        ImagesListService.shared.clearImagesList()
    }
    
    private func clearAuthToken() {
        OAuth2TokenStorage().bearerToken = nil
    }
    
    private func navigateToInitialScreen() {
        DispatchQueue.main.async {
            guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window else { return }
            
            let splashVC = SplashViewController()
            let navController = UINavigationController(rootViewController: splashVC)
            
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
