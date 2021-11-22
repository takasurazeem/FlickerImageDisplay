//
//  FlickerImage.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import Foundation

// MARK: - FlickerImage
struct PhotoFeed: Decodable {
    let photos: Photos?
    let stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    let id, title, ownerName: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case ownerName = "ownername"
        case imageURL = "url_m"
    }
}

