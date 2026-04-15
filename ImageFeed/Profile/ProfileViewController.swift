//
//  File.swift
//  ImageFeed
//
//  Created by Сергей Петров on 06.02.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    private var presenter: ProfilePresenterProtocol!
    
    private let avatarImageView = UIImageView()
    private let fullNameLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let bioLabel = UILabel()
    private let logoutButton = UIButton(type: .custom)
    
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage.shared
    private let logoutService = ProfileLogoutService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var skeletonLayers: [CAGradientLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        setupAvatarImageView()
        setupFullNameLabel()
        setupNickNameLabel()
        setupBioLabel()
        setupLogoutButton()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        skeletonLayers.forEach { layer in
            layer.frame = layer.superlayer?.bounds ?? .zero
        }
    }
    
    private func makeSkeletonLayer(for view: UIView, cornerRadius: CGFloat) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.cornerRadius = cornerRadius
        
        gradient.colors = [
            UIColor(white: 0.85, alpha: 1).cgColor,
            UIColor(white: 0.75, alpha: 1).cgColor,
            UIColor(white: 0.85, alpha: 1).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.5, 1]
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        
        gradient.add(animation, forKey: "skeletonAnimation")
        
        return gradient
    }
    
    private func showSkeleton() {
        view.layoutIfNeeded()

        let avatarSkeleton = makeSkeletonLayer(for: avatarImageView, cornerRadius: 35)
        avatarImageView.layer.addSublayer(avatarSkeleton)
        skeletonLayers.append(avatarSkeleton)

        let nameSkeleton = makeSkeletonLayer(for: fullNameLabel, cornerRadius: 8)
        fullNameLabel.layer.addSublayer(nameSkeleton)
        skeletonLayers.append(nameSkeleton)

        let loginSkeleton = makeSkeletonLayer(for: nickNameLabel, cornerRadius: 8)
        nickNameLabel.layer.addSublayer(loginSkeleton)
        skeletonLayers.append(loginSkeleton)

        let bioSkeleton = makeSkeletonLayer(for: bioLabel, cornerRadius: 8)
        bioLabel.layer.addSublayer(bioSkeleton)
        skeletonLayers.append(bioSkeleton)
    }
    
    private func hideSkeleton() {
        skeletonLayers.forEach { $0.removeFromSuperlayer() }
        skeletonLayers.removeAll()
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupAvatarImageView() {
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
    
    func updateProfileDetails(profile: Profile) {
        fullNameLabel.text = profile.name.isEmpty
        ? "Имя не указано"
        : profile.name
        nickNameLabel.text = profile.loginName.isEmpty
        ? "@неизвестный_пользователь"
        : profile.loginName
        bioLabel.text = (profile.bio?.isEmpty ?? true)
        ? "Профиль не заполнен"
        : profile.bio
        
        hideSkeleton()

    }
    
    @objc private func didTapLogoutButton() {
        showLogoutAlert()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let logoutAction = UIAlertAction(title: "Да", style: .default) { _ in
            self.logoutService.logout()
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func showLogoutConfirmation() {
       let alert = UIAlertController(
           title: "Пока, пока!",
           message: "Уверены, что хотите выйти?",
           preferredStyle: .alert
       )


        let logoutAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
                self?.presenter.confirmLogout()
            }
       
       let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
     
       alert.addAction(logoutAction)
       alert.addAction(cancelAction)

       present(alert, animated: true)
   }
    
    func displayAvatar(url: URL?) {
        guard let url else {
            hideSkeleton()
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        avatarImageView.kf.setImage(
            with: url,
            options: [.processor(processor)]
        ) { [weak self] _ in
            self?.hideSkeleton()
        }
    }
    
}
