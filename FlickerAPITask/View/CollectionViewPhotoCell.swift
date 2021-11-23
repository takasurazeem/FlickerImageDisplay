//
//  CollectionViewPhotoCell.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import UIKit

class CollectionViewPhotoCell: UICollectionViewCell {
  
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageOwnerLabel: UILabel!
    @IBOutlet weak var isFavouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func load(photo: PhotoFeedCollectionViewCellViewModel?) {
        guard let data = photo else {
            return
        }
        if let url = data.imageURL {
            photoView.load(url)
        }
        imageTitleLabel.text = data.imageTitle
        imageOwnerLabel.text = data.imageOwnerLabel
        isFavouriteButton.setImage(data.isFavouriteButtonImage, for: .normal)
    }
    
}

