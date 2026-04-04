//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Сергей Петров on 10.02.2026.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var imageURL: URL?

    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupActivityIndicator()
        loadImage()
        
    }
    
    @IBAction private func didTapBackwardButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func loadImage() {
        guard let url = imageURL else { return }
        
        activityIndicator.startAnimating()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let value):
                self.imageView.image = value.image
                self.imageView.sizeToFit()
                self.rescaleAndCenterImageInScrollView(image: value.image)
                
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
            let alert = UIAlertController(
                title: "Ошибка загрузки",
                message: "Не удалось загрузить изображение. Проверьте соединение с интернетом.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                self?.loadImage()
            })
            
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            
            present(alert, animated: true)
        }
    
    private func setupActivityIndicator() {
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        updateInsetsForCentering()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func configure(with image: UIImage) {
        
        imageView.image = image
        imageView.frame = CGRect(origin: .zero, size: image.size)
        scrollView.contentSize = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func updateInsetsForCentering() {
        let boundsSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        
        let horizontalInset = max(0, (boundsSize.width - contentSize.width) / 2)
        let verticalInset = max(0, (boundsSize.height - contentSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        updateInsetsForCentering()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateInsetsForCentering()
    }
}
