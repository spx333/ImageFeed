//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Сергей Петров on 26.03.2026.
//

import Foundation

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String

    private enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}
