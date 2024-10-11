//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Nurbol on 30.09.2024.
//

import Foundation

enum ImageListError: Error {
    case invalidToken
    case invalidRequest
    case decodingError
}

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage()
    static let shared = ImagesListService()
    private init() { }
    private var currentPageNumber = 1
    
    private func makeGetPhotosRequest(token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.defaultBaseURLString + "/photos") else {
            assertionFailure("Failed to create urlComponents")
            return nil
        }
        urlComponents.queryItems = [.init(name: "page", value: String(currentPageNumber))]
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeChangeLikeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest? {
        let urlString = Constants.defaultBaseURLString + "/photos/\(photoId)/like"
        
        guard let url = URL(string: urlString) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo],Error>) -> Void) {
        
        if task != nil {
            return
        }
        
        guard let token = tokenStorage.bearerToken else {
            completion(.failure(ImageListError.invalidToken))
            return
        }
        
        guard let request = makeGetPhotosRequest(token: token) else {
            completion(.failure(ImageListError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self else { return}
            switch result {
            case .success(let photoResults):
                self.currentPageNumber += 1
                let newPhotos = photoResults.map { Photo(from: $0) }
                self.photos += newPhotos
                completion(.success(self.photos))
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": newPhotos]
                )
            case .failure(let error):
                print("Error decoding photos: \(error.localizedDescription)")
                completion(.failure(ImageListError.decodingError))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenStorage.bearerToken else {
            completion(.failure(ImageListError.invalidToken))
            return
        }
        
        guard let request = makeChangeLikeRequest(token: token, photoId: photoId, isLike: isLike) else {
            completion(.failure(ImageListError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResponse, Error>) in
            guard let self else { return }
            
            switch result {
            case .success:
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photoId": photoId, "isLiked": isLike]
                )
                completion(.success(()))
            case .failure(let error):
                print("Error changing like status: \(error.localizedDescription)")
                completion(.failure(ImageListError.decodingError))
            }
            self.likeTask = nil
        }
        likeTask = task
        task.resume()
    }
    
    func clearImagesList() {
        photos.removeAll()
        task = nil
        likeTask = nil
        currentPageNumber = 1
    }
}
