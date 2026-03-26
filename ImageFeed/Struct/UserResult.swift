//
//  UserResult.swift
//  ImageFeed
//
//  Created by Сергей Петров on 26.03.2026.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
