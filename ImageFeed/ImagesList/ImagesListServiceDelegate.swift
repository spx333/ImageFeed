//
//  ImagesListServiceDelegate.swift
//  ImageFeed
//
//  Created by Сергей Петров on 15.04.2026.
//

import Foundation

protocol ImagesListServiceDelegate: AnyObject {
    func imagesListServiceDidUpdatePhotos(
        _ service: ImagesListServiceProtocol
    )
    
    func imagesListServiceDidUpdatePhoto(
        _ service: ImagesListServiceProtocol,
        at index: Int
    )
}
