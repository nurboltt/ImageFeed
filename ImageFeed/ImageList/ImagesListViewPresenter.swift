//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Nurbol on 16.10.2024.
//

import UIKit

public protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func loadNextPage()
    func numberOfRows() -> Int
    func configureCell(_ cell: ImagesListCell, at indexPath: IndexPath)
    func prepareForSingleImageSegue(_ viewController: SingleImageViewController, at indexPath: IndexPath)
    func likePhoto(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    private let inputFormatter = ISO8601DateFormatter()
    private let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func viewDidLoad() {
        view?.reloadData()
        loadNextPage()
    }
    
    func loadNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            switch result {
            case .success:
                self?.view?.reloadData()
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func numberOfRows() -> Int {
        return imagesListService.photos.count
    }
    
    @MainActor func configureCell(_ cell: ImagesListCell, at indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        if let imageUrl = URL(string: photo.largeImageURL), let createdAt = photo.createdAt {
            cell.cellImageView.kf.indicatorType = .activity
            cell.cellImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Stub"))
            
            if let date = inputFormatter.date(from: createdAt) {
                cell.dateLabel.text = outputFormatter.string(from: date)
            } else {
                cell.dateLabel.text = nil
            }
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "like") : UIImage(named: "unlike")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func heightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        let photo = imagesListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func prepareForSingleImageSegue(_ viewController: SingleImageViewController, at indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        viewController.photo = photo
    }
    
    func likePhoto(at indexPath: IndexPath) {
        guard indexPath.row < imagesListService.photos.count else { return }
        let photo = imagesListService.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.imagesListService.photos[indexPath.row] = newPhoto
                    self.view?.reloadRow(at: indexPath)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    self.view?.presentErrorAlert(message: "Failed to update like status")
                }
            }
        }
    }
}
