//
//  PhotosCollectionViewController.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import UIKit

private let reuseIdentifier = "CollectionViewPhotoCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    var photosFeed: PhotoFeed?
    
    let photosFeedService = PhotoFeedNetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registers cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        photosFeedService.getPhotoFeed { photoFeed, error in
            self.photosFeed = photoFeed
            DispatchQueue.main.async {
                self.collectionView!.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFeed?.photos?.photo?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewPhotoCell
        let photo = photosFeed?.photos?.photo?[indexPath.row]
        cell.load(photo: photo)
        return cell
    }
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200.0)
    }
    
}
