//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Сергей Петров on 06.04.2026.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
