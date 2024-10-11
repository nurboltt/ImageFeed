//
//  Array+Extension.swift
//  ImageFeed
//
//  Created by Nurbol on 11.10.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

extension Array where Element == Photo {
    func withReplaced(at index: Int, new photo: Photo) -> [Photo] {
        var newArray = self
        newArray[index] = photo
        return newArray
    }
}

