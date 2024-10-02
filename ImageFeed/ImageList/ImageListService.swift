//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Nurbol on 30.09.2024.
//

import Foundation

final class ImageListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage()
    static let shared = ImageListService()
    private init() { }
    
    func makeGetPhotosRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

     func fetchPhotosNextPage(completion: @escaping (Result<[Photo],Error>) -> Void) {
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
            // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
//        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        
            guard let token = tokenStorage.bearerToken else {
                completion(.failure(ProfileServiceError.invalidToken))
                return
            }
            
            task?.cancel()
            
            guard let request = makeGetPhotosRequest(token: token) else {
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
            
            let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[Photo],Error>) in
                guard let self else { return}
                switch result {
                case .success(let photo):
                    self.photos = photo
                    completion(.success(photo))
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": photo]
                    )
                    print("!!!photo:\(photo)")
                case .failure(let error):
                    print("Error decoding: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                self.task = nil
            }
          
            self.task = task
            task.resume()
    }
}
