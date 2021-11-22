//
//  PhotoFeedNetworkService.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import Foundation

struct PhotoFeedNetworkService {
    
    func getPhotoFeed(completion: @escaping ((_ photoFeed: PhotoFeed?, _ error: Error?) -> Void)) {
        
        let url = URL(string: photosFeedURL)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                do {
                    // Try decoding your data to your model
                    let photoFeed = try JSONDecoder().decode(PhotoFeed.self, from: data)
                    // call completion with your models array, no error
                    completion(photoFeed, nil)
                }
                catch {
                    // there's a decoding error, call completion with decoding error
                    completion(nil, error)
                }
//                print(String(data: data, encoding: .utf8)!)
            }
            
        }

        task.resume()
    }
    
}
