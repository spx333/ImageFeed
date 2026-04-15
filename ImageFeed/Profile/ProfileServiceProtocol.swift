//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Сергей Петров on 15.04.2026.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
}
