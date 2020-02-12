//
//  persistenceHelper.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/4/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import Foundation
enum DataPersistenceError: Error{
    case savingError(Error) // associated value
    case fileDoesNotExist(String)
    case noData
    case decodingError(Error)
    case deletingError(Error)
}

class PersistenceHelper {
    
    private var photos = [ImageObject]()
    
    private var filename: String
    
    init(filename: String) {
      self.filename = filename
    }
    

    
    private func save() throws {
        // step 1.
         // get url path to the file that the Event will be saved to
         let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        // events array will be object being converted to Data
        // we will use the Data object and write (save) it to documents directory
        do {
          // step 3.
          // convert (serialize) the events array to Data
          let data = try PropertyListEncoder().encode(photos)
          
          // step 4.
          // writes, saves, persist the data to the documents directory
          try data.write(to: url, options: .atomic)
        } catch {
          // step 5.
          throw DataPersistenceError.savingError(error)
        }
      }

      // for re-ordering
    // you are deleting, an item from the array of ImageObject and than rearranging the items and than saving the new array of items.
        // this code is mainly for deleting / updating and saving.
        
      public func sync(items: [ImageObject]) {
        self.photos = items
        try? save()
      }
      
      // DRY - don't repeat yourself
      
      // create - save item to documents directory
      public func create(item: ImageObject) throws {
        // step 2.
        // append new event to the events array
        photos.append(item)
        
        do {
          try save()
        } catch {
          throw DataPersistenceError.savingError(error)
        }
      }
    
      //MARK: this loads all the events into the view controller
    public func loadPhotos() throws -> [ImageObject] {
      // we need access to the filename URL that we are reading from
      // this give the location inside the device
      let url = FileManager.pathToDocumentsDirectory(with: filename)
      
      // if there is an actual file in the device than you take the data in that device
      // this verify if the file exsit
      if FileManager.default.fileExists(atPath: url.path) {
          //checks what is in the file
        if let data = FileManager.default.contents(atPath: url.path) {
          do {
              // This converts the information inside url.path into data than if it cant it will throw an error because it cant decode from the url data into image
            photos = try PropertyListDecoder().decode([ImageObject].self, from: data)
          } catch {
            throw DataPersistenceError.decodingError(error)
          }
        } else {
          throw DataPersistenceError.noData
        }
      }
      else {
        throw DataPersistenceError.fileDoesNotExist(filename)
      }
      return photos
    }
        

    
    //MARK: delete - remove item from documents directory
    public func delete(event index: Int) throws {
      // remove the item from the events array
      photos.remove(at: index)
      
      // save our events array to the documents directory
      do {
        try save()
      } catch {
        throw DataPersistenceError.deletingError(error)
      }
    }
}
