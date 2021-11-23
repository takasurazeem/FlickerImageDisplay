//
//  PhotoFeedCollectionViewCellViewModel.swift
//  FlickerAPITask
//
//  Created by Takasur A. on 23/11/2021.
//

import UIKit

struct PhotoFeedCollectionViewCellViewModel {
    let imageTitle: String?
    let imageOwnerLabel: String?
    let imageURL: URL?
    var isFavorite: Bool? {
        // TODO: Calculate it here
        false
    }
    var isFavouriteButtonImage: UIImage? {
        isFavorite ?? false ? UIImage(systemName: "star.circle.fill") : UIImage(systemName: "star.circle")
    }
}
