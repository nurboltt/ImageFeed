//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nurbol on 19.10.2024.
//

import ImageFeed
import Foundation
import UIKit

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var loadNextPageCalled: Bool = false
    var likePhotoCalled: Bool = false
    var photos: [Photo] = []
    var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func loadNextPage() {
        loadNextPageCalled = true 
    }
    
    func numberOfRows() -> Int {
        photos.count
    }
    
    func prepareForSingleImageSegue(_ viewController: SingleImageViewController, at indexPath: IndexPath) {
        guard indexPath.row < photos.count else { return }
        let photo = photos[indexPath.row]
        viewController.photo = photo
    }
    
    func likePhoto(at indexPath: IndexPath) {
        likePhotoCalled = true
        guard indexPath.row < photos.count else { return }
        var photo = photos[indexPath.row]
        photo.isLiked.toggle()
        photos[indexPath.row] = photo
    }
    
    func heightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        guard indexPath.row < photos.count else { return .zero }
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        return photo.size.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func configureCell(_ cell: ImagesListCell, at indexPath: IndexPath) { }
}

