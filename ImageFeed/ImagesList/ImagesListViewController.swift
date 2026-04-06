//
//  ViewController.swift
//  ImageFeed
//
//  Created by Сергей Петров on 30.01.2026.
//

import UIKit
import Kingfisher


final class ImagesListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var observer: NSObjectProtocol?

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        photos = imagesListService.photos
        setupNotificationObserver()
        
        if photos.isEmpty {
                imagesListService.fetchPhotosNextPage()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
     }
    
    deinit {
        guard let observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath =  sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination or sender")
                return
            }
            
            let photo = photos[indexPath.row]
            viewController.imageURL = URL(string: photo.largeImageURL)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setupNotificationObserver() {
                observer = NotificationCenter.default.addObserver(
                    forName: ImagesListService.didChangeNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    self?.updateTableViewAnimated()
                }
            }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        guard newCount > oldCount else { return }
        
        photos = imagesListService.photos
        
        let indexPaths = (oldCount..<newCount).map {
            IndexPath(row: $0, section: 0)
        }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        cell.dateLabel.text = photo.createdAt.map {
            dateFormatter.string(from: $0)
        }
        
        let likeImage = photo.isLiked
             ? UIImage(named: "Active")
             : UIImage(named: "No_Active")
         
         cell.likeButton.setImage(likeImage, for: .normal)
         
         let placeholder = UIImage(named: "Stub")
         
         cell.cellImage.kf.indicatorType = .activity
         
         cell.cellImage.kf.setImage(
             with: URL(string: photo.thumbImageURL),
             placeholder: placeholder
         )
        
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось выполнить действие. Попробуйте ещё раз.",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "ОК", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ImagesListCell.reuseIdentifier,
                    for: indexPath
                ) as? ImagesListCell else {
                    return UITableViewCell()
                }
        cell.delegate = self
        configCell(for: cell, with: indexPath)
        
        return cell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard photos.indices.contains(indexPath.row) else { return 0 }
        let photo = photos[indexPath.row]
        

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        
        guard imageWidth > 0 else { return 0 }
        
        let scale = imageViewWidth / imageWidth
        return imageHeight * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView,
                    willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked
        ) { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    
                    self.photos = self.imagesListService.photos
                    
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                case .failure:
                    self.showErrorAlert()
                }
                
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

