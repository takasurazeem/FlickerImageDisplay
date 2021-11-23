//
//  FavouritesCollectionViewController.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 23/11/2021.
//

import UIKit
import CoreData

class FavouritesCollectionViewController: UICollectionViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Favourites>!
    
    // MARK: - CoreData
    private var blockOperations: [BlockOperation] = []
    
    func setupFetchedResultsController() {
        let request : NSFetchRequest<Favourites> = Favourites.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [sort]
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            fatalError("Could not perform fetch: \(error)")
        }
    }
    
    // MARK: - LifeCycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewPhotoCell
        
        let favourite = fetchedResultsController.object(at: indexPath)
        cell.load(from: favourite)
        
        return cell
    }
    
    // MARK: Deinit
    
    deinit {
        blockOperations.forEach { $0.cancel() }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
}

extension FavouritesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200.0)
    }
    
}

extension FavouritesCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        blockOperations.removeAll(keepingCapacity: false)
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = indexPath else {
                return
            }
            let op = BlockOperation { [weak self] in
                self?.collectionView.insertItems(at: [indexPath])
            }
            blockOperations.append(op)
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            let op = BlockOperation { [weak self] in
                self?.collectionView.deleteItems(at: [indexPath])
            }
            blockOperations.append(op)
        case .update:
            guard let indexPath = indexPath else {
                return
            }
            let op = BlockOperation { [weak self] in
                self?.collectionView.reloadItems(at: [indexPath])
            }
            blockOperations.append(op)
        default:
            collectionView.reloadData()
        }
    }
    
}
