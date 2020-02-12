//
//  WeatherSearchController.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/4/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit

class WeatherSearchController: UIViewController {
    
    private var weatherSearchView = WeatherSearchView()
    
    private var weeklyDidSet = [DailyForecast](){
        didSet{
            DispatchQueue.main.async {
                self.weatherSearchView.collectionView.reloadData()
            }
        }
        
    }
    private var pic = [Picture]()
    
     public var persistenceHelper = PersistenceHelper(filename: "fave.plist")
    
    private var zipcodeDidSet = String(){
        didSet{
            getCordinates(zipcode: zipcodeDidSet)
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
        zipcodeDidSet = UserPreference.shared.getZipcode() ?? ""
        weatherSearchView.collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        }
    
    
    public func getCordinates(zipcode: String) {
        ZipCodeHelper.getLatLong(fromZipCode: zipcodeDidSet) {[weak self] (result) in
            switch result {
            case . failure(let zipcodeError):
                print("getCordinates error \(zipcodeError)")
            case .success(let cordinates):
                self?.getWeather(lat: cordinates.lat, long: cordinates.long)
                DispatchQueue.main.async {
                    self?.weatherSearchView.cityNameLabel.text = cordinates.placeName
                 
                self?.loadPhotoData(photo: cordinates.placeName)
                
                }
            }
        }
        dump(pic)
    }
    
    public func getWeather(lat:Double, long: Double) {
        WeatherAPIClient.getWeather(lat: lat, long: long) { [weak self] (result) in
            switch result {
            case.failure(let appError):
                print("getWeather error: \(appError)")
            case .success(let dailyForecast):
                self?.weeklyDidSet = dailyForecast
//                DispatchQueue.main.async {
////                    self?.weatherSearchView.summaryLabel.text = dailyForecas
//                }
                
            }
        }
    }
    
    public func loadPhotoData(photo: String) {
        PhotoAPIClient.getPhotoJournals(for: photo) { [weak self] (result) in
            switch result {
            case .failure(let photoError):
                print("photoError")
            case .success(let picture):
                self?.pic = picture
            }
        }
    }

} // class curly

extension WeatherSearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        zipcodeDidSet = textField.text ?? ""
        UserPreference.shared.updateZodiac(with: zipcodeDidSet)
        getCordinates(zipcode: zipcodeDidSet)
        textField.resignFirstResponder()
        return true
    }
}

extension WeatherSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 0.3
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 1
        let totalSpace: CGFloat = numberOfItems * itemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpace) / numberOfItems
        return CGSize(width: itemWidth/3, height: itemWidth/1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 1, bottom: 20, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = weeklyDidSet[indexPath.row]
        let detailVC = DetailVC()
        detailVC.dayForecast = day
        detailVC.picture = pic[indexPath.row]
      detailVC.persistenceHelper = persistenceHelper
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
extension WeatherSearchController: UICollectionViewDataSource {
    
    //MARK: cellForITemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = weatherSearchView.collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            fatalError("could not cast as WeatherCell")
        }
        let forcast = weeklyDidSet[indexPath.row]
        cell.backgroundColor = .systemTeal
        cell.configureCell(weather: forcast)
        return cell
    }
    //MARK: numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeklyDidSet.count
        
    }
}
