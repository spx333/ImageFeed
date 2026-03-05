//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Сергей Петров on 04.03.2026.
//

import Foundation

final class OAuth2TokenStorage {
    private let defaults = UserDefaults.standard
    private let tokenKey = "com.imagefeed.oauth.bearerToken"
    
    var token: String? {
        get {
            defaults.string(forKey: tokenKey)
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: tokenKey)
            } else {
                defaults.removeObject(forKey: tokenKey)
            }
        }
    }
}
