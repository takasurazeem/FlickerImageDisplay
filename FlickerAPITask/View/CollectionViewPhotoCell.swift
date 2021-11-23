//
//  CollectionViewPhotoCell.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 22/11/2021.
//

import UIKit
import CoreData

class CollectionViewPhotoCell: UICollectionViewCell {
  
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageOwnerLabel: UILabel!
    @IBOutlet weak var addToFavouriteButton: UIButton!
    @IBOutlet weak var removeFromFavouriteButton: UIButton!
    
    fileprivate var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func load(photo: PhotoFeedCollectionViewCellViewModel?) {
        guard let data = photo else {
            return
        }
        if let url = data.imageURL {
            photoView.load(url)
            self.url = url.absoluteString
        }
        imageTitleLabel.text = data.imageTitle
        imageOwnerLabel.text = data.imageOwnerLabel
        
        if data.isFavorite {
            removeFromFavouriteButton.isHidden = false
            addToFavouriteButton.isHidden = true
        } else {
            removeFromFavouriteButton.isHidden = true
            addToFavouriteButton.isHidden = false
        }
        
    }
    
    func load(from favourite: Favourites) {
        if let url = URL(string: favourite.imageURL ?? "") {
            photoView.load(url)
            self.url = url.absoluteString
            removeFromFavouriteButton.isHidden = false
            addToFavouriteButton.isHidden = true
        }
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let favouritesEntity = NSEntityDescription.entity(forEntityName: "Favourites", in: managedContext)!
        
        let favourite = Favourites(entity: favouritesEntity, insertInto: managedContext)
        favourite.imageURL = self.url!
        
        do {
            try managedContext.save()
            sender.isHidden = true
            removeFromFavouriteButton.isHidden = false
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    @IBAction func removeFromFavourites(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        fetchRequest.predicate = NSPredicate(format: "imageURL =%@", url!)
        do {
            let delete = try managedContext.fetch(fetchRequest)
            
            if delete.count == 0 {
                sender.isHidden = true
                addToFavouriteButton.isHidden = false
                return
            }
            
            let objectToDelete = delete[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            
            try managedContext.save()
            
            sender.isHidden = true
            addToFavouriteButton.isHidden = false
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
}

