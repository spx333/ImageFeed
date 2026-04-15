//
//  ProfileViewProtocol.swift
//  ImageFeed
//
//  Created by Сергей Петров on 15.04.2026.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func updateProfileDetails(profile: Profile)
    func displayAvatar(url: URL?)
    func showLogoutConfirmation()

}
