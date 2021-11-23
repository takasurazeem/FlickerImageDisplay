//
//  PhotoFeedCollectionViewCellViewModel.swift
//  FlickerAPITask
//
//  Created by Takasur A. on 23/11/2021.
//

import UIKit
import CoreData

struct PhotoFeedCollectionViewCellViewModel {
    let imageTitle: String?
    let imageOwnerLabel: String?
    let imageURL: URL?
    var isFavorite: Bool {
        if let imageURL = imageURL?.absoluteString {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
            fetchRequest.predicate = NSPredicate(format: "imageURL =%@", imageURL)
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 1 {
                    return true
                }
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
        return false
    }
}
