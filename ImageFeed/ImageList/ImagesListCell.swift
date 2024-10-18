//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nurbol on 05.08.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

public class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet public weak var likeButton: UIButton!
    @IBOutlet public weak var cellImageView: UIImageView!
    @IBOutlet public weak var dateLabel: UILabel!
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imagesListCellDidTapLike(self)
    }
    
   public func setIsLiked(_ isLike: Bool) {
        let likeImage = isLike ? UIImage(named:"like") : UIImage(named:"unlike")
        self.likeButton.setImage(likeImage, for: .normal)
    }
}
