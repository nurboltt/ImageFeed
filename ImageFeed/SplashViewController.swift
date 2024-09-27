//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Nurbol on 29.08.2024.
//

import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenIdentifier = "showAuthenticationScreenIdentifier"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private lazy var splashImage: UIImageView = {
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor(red: 26.0/255.0, green: 27/255.0, blue: 34.0/255.0, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashImageConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.bearerToken != nil {
            switchToTabBarController()
        } else {
            createAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: Private functions
    
    private func setupSplashImageConstraints() {
        NSLayoutConstraint.activate([
            splashImage.widthAnchor.constraint(equalToConstant: 75),
            splashImage.heightAnchor.constraint(equalToConstant: 77.68),
            splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createAuthViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        } else {
            print("Failed to create viewController")
            return
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: Extension - SplashViewController

extension SplashViewController {
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.bearerToken = token
                fetchProfile()
                self.switchToTabBarController()
            case .failure(let error):
                print("Failed fetch token \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile {  result in
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(profile.username ?? "")
                self.switchToTabBarController()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchProfileImageURL(_ username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username: username) { result in
            switch result {
            case .success(let imageUrl):
                print(imageUrl)
            case .failure(let error):
                print(error.localizedDescription)
            }
            print(result)
        }
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        self.fetchOAuthToken(code)
    }
}
