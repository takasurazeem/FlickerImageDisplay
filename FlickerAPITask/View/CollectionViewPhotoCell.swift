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

extension UIImageView {
    /// Loads image from web asynchronosly and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func load(_ url: URL, placeholder: UIImage? = UIImage(systemName: "photo.fill"), cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
            }
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
