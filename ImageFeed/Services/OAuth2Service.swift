//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Сергей Петров on 03.03.2026.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String?
        let scope: String?
        let createdAt: Int?
        let refreshToken: String?
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
            case refreshToken = "refresh_token"
        }
    }
    
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            let error = NetworkError.invalidRequest
            print("OAuth2Service: Ошибка запроса: \(error)")
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let data):
                    
                    let tokenResponse = data.accessToken
                    self.tokenStorage.token = tokenResponse
                    completion(.success(tokenResponse))
                    
                case .failure(let error):
                    print("OAuth2Service: Ошибка запроса: \(error)")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
}
