//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Сергей Петров on 27.02.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        
        }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
    
    
    
    
}
