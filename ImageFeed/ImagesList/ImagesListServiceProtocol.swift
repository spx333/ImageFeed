//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Сергей Петров on 15.04.2026.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    var delegate: ImagesListServiceDelegate? { get set }
    
    func fetchPhotosNextPage()
    func changeLike(
        photoId: String,
        isLike: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
