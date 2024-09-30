//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Nurbol on 28.08.2024.
//

import UIKit

private enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data,Error>) -> Void
    ) -> URLSessionTask {
        let fullfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    fullfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("Network error with code: \(statusCode)")
                    fullfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error {
                print("Network error: \(error)")
                fullfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else if error != nil {
                print("Network error: urlSessionError")
                fullfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable> (
        for request: URLRequest,
        completion: @escaping (Result<T,Error>) -> Void
    ) -> URLSessionTask {
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    print("Decoding error: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "No data")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}
