//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nurbol on 19.10.2024.
//

import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {

    var presenter:ImagesListViewPresenterProtocol?
    var reloadDataCalled: Bool = false
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func reloadRow(at indexPath: IndexPath) { }
    func presentErrorAlert(message: String) { }
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) { }
}

