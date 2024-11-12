//
//  ImagesListViewPresenterTests.swift
//  ImageFeedTests
//
//  Created by Nurbol on 17.10.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewPresenterTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.reloadDataCalled)
    }
    
    func testLoadNextPage() {
      let presenter = ImagesListViewPresenterSpy()
        presenter.loadNextPage()
        XCTAssertTrue(presenter.loadNextPageCalled)
    }
    
    func testNumberOfRows() {
        let presenter = ImagesListViewPresenterSpy()
        
        let photo1 = Photo(id: "1", size: CGSize(width: 100, height: 200), createdAt: "2024-01-01T12:00:00Z", welcomeDescription: "Photo 1", thumbImageURL: "thumb1.jpg", largeImageURL: "large1.jpg", isLiked: false)
        let photo2 = Photo(id: "2", size: CGSize(width: 200, height: 300), createdAt: "2024-02-01T12:00:00Z", welcomeDescription: "Photo 2", thumbImageURL: "thumb2.jpg", largeImageURL: "large2.jpg", isLiked: true)
        
        presenter.photos = [photo1, photo2]
        let numberOfRows = presenter.numberOfRows()
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testLikePhoto() {
        let presenter = ImagesListViewPresenterSpy()

        let photo = Photo(id: "1", size: CGSize(width: 100, height: 200), createdAt: "2024-01-01T12:00:00Z", welcomeDescription: "Test Photo", thumbImageURL: "thumb1.jpg", largeImageURL: "large1.jpg", isLiked: false)

        presenter.photos = [photo]
        presenter.likePhoto(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(presenter.likePhotoCalled)
    }
    
    func testHeightForRow() {
        let presenter = ImagesListViewPresenterSpy()
        
        let photo = Photo(
            id: "1",
            size: CGSize(width: 100, height: 200),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "thumb.jpg",
            largeImageURL: "large.jpg",
            isLiked: false
        )
        
        presenter.photos = [photo]
        let indexPath = IndexPath(row: 0, section: 0)
        let height = presenter.heightForRow(at: indexPath, tableViewWidth: 300)
        XCTAssertGreaterThan(height, 0)
    }

}
