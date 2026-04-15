//
//  ImagesListViewProtocol.swift
//  ImageFeed
//
//  Created by Сергей Петров on 15.04.2026.
//

import Foundation

protocol ImagesListViewProtocol: AnyObject {
    func insertRows(at indexPaths: [IndexPath])
        func reloadRow(at index: Int)
        func showError(message: String)

}
