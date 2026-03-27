//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Сергей Петров on 27.03.2026.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

extension PhotoResult {
    func toPhoto(dateFormatter: ISO8601DateFormatter) -> Photo {
        return Photo(
            id: id,
            size: CGSize(width: width, height: height),
            createdAt: createdAt.flatMap { dateFormatter.date(from: $0) },
            welcomeDescription: description,
            thumbImageURL: urls.thumb,
            largeImageURL: urls.full,
            isLiked: likedByUser
        )
    }
}
