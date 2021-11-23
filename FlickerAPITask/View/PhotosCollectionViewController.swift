//
//  PhotosCollectionViewController.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import UIKit

private let reuseIdentifier = "CollectionViewPhotoCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    private var photosViewModel: PhotoFeedViewModel?
    let photosFeedService = PhotoFeedNetworkService()

    let activityView = UIActivityIndicatorView(style: .large)
    let fadeView: UIView = UIView()
    
    fileprivate func addFadeView() {
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.4
        
        self.view.addSubview(fadeView)
    }
    
    fileprivate func addLoader() {
        addFadeView()
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
    fileprivate func loadImagesFromServer() {
        addLoader()
        photosFeedService.getPhotoFeed { [weak self] photoFeed, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.fadeView.removeFromSuperview()
                self.activityView.stopAnimating()
            }
            if error == nil {
                self.photosViewModel = PhotoFeedViewModel(feed: photoFeed!)
                DispatchQueue.main.async {
                    self.collectionView!.reloadData()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registers cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        photosViewModel?.photos.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        loadImagesFromServer()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel?.photos.value?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewPhotoCell
        let photo = photosViewModel?.photos.value?[indexPath.row]
        cell.load(photo: photo)
        return cell
    }
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200.0)
    }
    
}
