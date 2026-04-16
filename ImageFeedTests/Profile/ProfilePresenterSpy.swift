//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Сергей Петров on 16.04.2026.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutCalled = false
    var confirmLogoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogout() {
        didTapLogoutCalled = true
    }
    
    func confirmLogout() {
        confirmLogoutCalled = true
    }
}
