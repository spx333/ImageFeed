//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Сергей Петров on 26.03.2026.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private let dateFormatter = ISO8601DateFormatter()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequest(page: nextPage) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            
            guard let self = self else { return }
            self.task = nil
            
            switch result {
                
            case .success(let results):
                let newPhotos = results.map { $0.toPhoto(dateFormatter: self.dateFormatter) }
                
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
                
            case .failure(let error):
                print("ImagesListService: Ошибка запроса: page=\(nextPage) error=\(error)")
                
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(page: Int) -> URLRequest? {
        
        guard let token = OAuth2TokenStorage.shared.token else { return nil }
        
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
