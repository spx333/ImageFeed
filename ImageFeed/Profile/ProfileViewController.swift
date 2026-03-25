//
//  File.swift
//  ImageFeed
//
//  Created by Сергей Петров on 06.02.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let avatarImageView = UIImageView()
    private let fullNameLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let bioLabel = UILabel()
    private let logoutButton = UIButton(type: .custom)
    
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatarImageView()
        setupFullNameLabel()
        setupNickNameLabel()
        setupBioLabel()
        setupLogoutButton()
        
        view.backgroundColor = .ypBlack
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(with: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func setupAvatarImageView() {
        //avatarImageView.image = UIImage(named: profile.avatar)
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
    
    private func setupFullNameLabel() {
        fullNameLabel.textColor = .ypWhite
        fullNameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullNameLabel)
        
        fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupNickNameLabel() {
        nickNameLabel.textColor = .ypGray
        nickNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        
        nickNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor).isActive = true
        nickNameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupBioLabel() {
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
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    private func updateProfileDetails(with profile: Profile) {
        fullNameLabel.text = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        nickNameLabel.text = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        bioLabel.text = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        
        print("imageURL: \(imageUrl)")
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                
                switch result {
                    
                case .success(let value):
                    
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @objc private func didTapLogoutButton() {
        print("logout")
    }
    
}
