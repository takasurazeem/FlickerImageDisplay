//
//  FlickerImage.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import Foundation

// MARK: - FlickerImage
struct PhotoFeedViewModel {
    var photos: Observable<[PhotoFeedCollectionViewCellViewModel]> = Observable([])
    
    init(feed: PhotoFeed) {
        photos.value = feed.photos?.photo?.compactMap({
            PhotoFeedCollectionViewCellViewModel(imageTitle: $0.title,
                                                 imageOwnerLabel: $0.ownerName,
                                                 imageURL: URL(string: $0.imageURL ?? ""))
        })
    }
}

