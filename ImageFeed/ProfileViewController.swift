//
//  File.swift
//  ImageFeed
//
//  Created by Сергей Петров on 06.02.2026.
//

import UIKit

struct Profile {
    let avatar: String
    let name: String
    let nick: String
    let bio: String
}

final class ProfileViewController: UIViewController {
    
    private let avatarImageView = UIImageView()
    private let fullNameLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let bioLabel = UILabel()
    private let logoutButton = UIButton(type: .custom)
    
    let mockProfile = Profile(
        avatar: "Photo",
        name: "Екатерина Новикова",
        nick: "@ekaterina_nov",
        bio: "Hello, world!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        setupAvatarImageView(profile: mockProfile)
        setupFullNameLabel(profile: mockProfile)
        setupNickNameLabel(profile: mockProfile)
        setupBioLabel(profile: mockProfile)
        setupLogoutButton()
    }
    
    private func setupAvatarImageView(profile: Profile) {
        avatarImageView.image = UIImage(named: profile.avatar)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupFullNameLabel(profile: Profile) {
        fullNameLabel.text = profile.name
        fullNameLabel.textColor = .ypWhite
        fullNameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullNameLabel)
        
        fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupNickNameLabel(profile: Profile) {
        nickNameLabel.text = profile.nick
        nickNameLabel.textColor = .ypGray
        nickNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        
        nickNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor).isActive = true
        nickNameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupBioLabel(profile: Profile) {
        bioLabel.text = profile.bio
        bioLabel.textColor = .ypWhite
        bioLabel.font = .systemFont(ofSize: 13, weight: .regular)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bioLabel)
        
        bioLabel.leadingAnchor.constraint(equalTo: nickNameLabel.leadingAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupLogoutButton() {
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
