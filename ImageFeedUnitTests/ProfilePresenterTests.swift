//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Nurbol on 15.10.2024.
//

@testable import ImageFeed
import XCTest

final class ProfilePresenterTests: XCTestCase {
    
    func testViewDidLoadUpdatesProfileDetailsAndAvatar() {
        let viewMock = ProfileViewMock()
        let profileServiceMock = ProfileServiceMock()
        let profileImageServiceMock = ProfileImageServiceMock()
        let presenter = ProfileViewPresenter(view: viewMock as ProfileViewProtocol, profileService: profileServiceMock as ProfileServiceProtocol, profileImageService: profileImageServiceMock as ProfileImageServiceProtocol)
        
        profileServiceMock.profile = Profile(username: "TestUser", name: "Test User", loginName: "@TestUser", bio: "Test Bio")
        profileImageServiceMock.avatarURL = "https://example.com/avatar.jpg"
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(viewMock.updatedName, "Test User")
        XCTAssertEqual(viewMock.updatedLogin, "@Test User")
        XCTAssertEqual(viewMock.updatedBio, "Test Bio")
        XCTAssertEqual(viewMock.avatarURL?.absoluteString, "https://example.com/avatar.jpg")
    }
    
    func testLogoutButtonTappedShowsLogoutConfirmation() {
        let viewMock = ProfileViewMock()
        let profileServiceMock = ProfileServiceMock()
        let profileImageServiceMock = ProfileImageServiceMock()
        let presenter = ProfileViewPresenter(view: viewMock as ProfileViewProtocol, profileService: profileServiceMock as ProfileServiceProtocol, profileImageService: profileImageServiceMock as ProfileImageServiceProtocol)
        
        presenter.logoutButtonTapped()
        
        XCTAssertTrue(viewMock.isLogoutConfirmationShown)
    }
}

