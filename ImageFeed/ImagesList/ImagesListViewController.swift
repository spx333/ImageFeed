//
//  ViewController.swift
//  ImageFeed
//
//  Created by Сергей Петров on 30.01.2026.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    var presenter: ImagesListPresenterProtocol!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        presenter.viewDidLoad()
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
            
            let photo = presenter.photo(at: indexPath.row)
            viewController.imageURL = URL(string: photo.largeImageURL)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = presenter.photo(at: indexPath.row)
        
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
        presenter.photosCount
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
        guard indexPath.row < presenter.photosCount else { return 0 }

        let photo = presenter.photo(at: indexPath.row)
        
        
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
        
        presenter.willDisplayCell(at: indexPath.row)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        
        presenter.didTapLike(at: indexPath.row)
    }
}

extension ImagesListViewController: ImagesListViewProtocol {
    
    
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        UIBlockingProgressHUD.dismiss()
    }
    
    func showError(message: String) {
        UIBlockingProgressHUD.dismiss()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

