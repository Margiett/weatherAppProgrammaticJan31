//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/5/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
public var favoritesView = FavoritesView()
    
    public var persistenceHelper = PersistenceHelper(filename:"fave.plist")
    
    
    weak var delegate: FavoritesDelegate?
    public var faveDidSet = [ImageObject]() {
        didSet {
            DispatchQueue.main.async {
                self.favoritesView.collectionView.reloadData()
            }
        }
    }
    
    override func loadView(){
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesView.collectionView.delegate = self
        favoritesView.collectionView.dataSource = self
        loadFavorites()
        
        favoritesView.collectionView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellWithReuseIdentifier: "favoritesCell")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadFavorites()
    }
    
    
    private func loadFavorites() {
        do {
            faveDidSet = try persistenceHelper.loadPhotos()
        } catch {
            print("unable to load favorites")
        }
    }
}
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faveDidSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoritesView.collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCell", for: indexPath) as? FavoritesCell else {
            fatalError("could not cast to favorites cell")
        }
        let fave = faveDidSet[indexPath.row]
    cell.configureCell(for: fave)
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.95
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

extension FavoritesViewController: FavoritesDelegate {
   
    func didLongPress(_ imageCell: FavoritesCell) {
        guard let indexPath = favoritesView.collectionView.indexPath(for: imageCell) else {
            return
          }
        // present an action sheet
        
        // actions: delete, cancel
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
          self?.deleteImageObject(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

    }
    private func deleteImageObject(indexPath: IndexPath) {
       persistenceHelper.sync(items: faveDidSet)
       do {
         faveDidSet = try persistenceHelper.loadPhotos()
       } catch {
         print("loading error: \(error)")
       }
       
       // delete imageObject from imageObjects
       faveDidSet.remove(at: indexPath.row)
       
       // delete cell from collection view
       favoritesView.collectionView.deleteItems(at: [indexPath])
       
       do {
         // delete image object from documents directory
         try persistenceHelper.delete(event: indexPath.row)
       } catch {
         print("error deleting item: \(error)")
       }
     }
    
    func addedToFaves(pic: ImageObject?) {
        faveDidSet.append(pic!)
    }
    
//    func addedToFaves(pic: ImageObject) {
//        faveDidSet.append(pic)
//    }
}
