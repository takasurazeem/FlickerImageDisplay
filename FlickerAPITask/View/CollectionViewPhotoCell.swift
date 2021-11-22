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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func load(photo: Photo?) {
        guard let photo = photo else {
            return
        }
        if let urlString = photo.imageURL,
           let url = URL(string: urlString) {
            photoView.load(url)
        }
        imageTitleLabel.text = photo.title
        imageOwnerLabel.text = photo.ownerName
    }
    
}

