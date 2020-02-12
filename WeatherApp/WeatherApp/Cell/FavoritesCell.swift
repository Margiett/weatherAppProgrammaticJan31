//
//  FavoritesCell.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/5/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit

class FavoritesCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    // step 2: creating custom delegation - define optional delegate variable
     weak var delegate: FavoritesDelegate!
     
     // step 1: long press setup
     // setup long press gesture recognizer
     private lazy var longPressGesture: UILongPressGestureRecognizer = {
       let gesture = UILongPressGestureRecognizer()
       gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
       return gesture
     }()
     
     override func layoutSubviews() {
       super.layoutSubviews()
       layer.cornerRadius = 20.0
       backgroundColor = .orange
       
       // step 3: long press setup - added gesture to view
       addGestureRecognizer(longPressGesture)
     }
    // step 2: long press setup
    // function gets called when long press is activated
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        
      if gesture.state == .began { // if gesture is active
        gesture.state = .cancelled
        return
      }
      
      // step 3: creating custom delegation - explicity use
      // delegate object to notify of any updates e.g
      // notifying the ImagesViewController when the user long presses on the cell
    delegate?.didLongPress(self)
      // cell.delegate = self
      // imagesViewController -> didLongPress(:)
    }
    
    
    
    public func configureCell(for fave: ImageObject){
        cellImageView.image = UIImage(data: fave.image)

        }
    }

