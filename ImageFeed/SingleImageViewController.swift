//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Сергей Петров on 10.02.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    

    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    @IBAction func didTapBackButon(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
