//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Сергей Петров on 05.02.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    private enum Assets {
        static let liked = UIImage(named: "Active")
        static let notLiked = UIImage(named: "No_Active")
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(isLiked ? Assets.liked : Assets.notLiked, for: .normal)
    }
    
}
