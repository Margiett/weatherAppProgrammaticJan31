//
//  WeatherSearchView.swift
//  WeatherApp
//
//  Created by Margiett Gil on 1/31/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit

class WeatherSearchView: UIViewController {
    private var weather: Weather? {
      didSet{
          DispatchQueue.main.async {
              self.weatherSearchView.collectionView.reloadData()
          }
          }
      }
      private var zipCode = String() {
          didSet{
              getCordinates(zipCode: zipCode)
          }
      }
      
      override func loadView() {
          view = weatherSearchView
      }

      override func viewDidLoad() {
          super.viewDidLoad()
          weatherSearchView.collectionView.delegate = self
          weatherSearchView.collectionView.dataSource = self
          weatherSearchView.textField.delegate = self
          weatherSearchView.collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
      }
      public func getCordinates(zipCode: String) {
          ZipCodeHelper.getLatLong(fromZipCode: zipCode) { [weak self] (result) in
              switch result {
              case .failure(let zopcodeError):
                  print("gtCoordinates error: \(zipcodeError)")
              case .success(let coordinates):
                  self?.weather?.latitude = coordinates.lat
                  self?.weather?.longitude = coordinates.long
                  self?.getWeather(lat: self?.weather?.latitude ?? 0, long: self?.weather?.longitude ?? 0)
              }
          }
      }
      
      public func getWeather(lat: Double, long: Double) {
      
      }
      

}
