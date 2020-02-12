//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/5/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit
import AVFoundation


protocol FavoritesDelegate: AnyObject {
    
    func addedToFaves(pic: ImageObject?)
    // list required functions, initializers, variables
    func didLongPress(_ imageCell: FavoritesCell)
}


class DetailVC: UIViewController {
    
    public var dayForecast: DailyForecast?
    public var picture: Picture!
    
    private var detailView = DetailView()
    private var faves = true
    
    weak var delegate: FavoritesDelegate?
    
    public var persistenceHelper = PersistenceHelper(filename: "fave.plist")
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateUI()
        configureNavigationBar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    
    }
    @objc
    private func doubleTapped () {
        
        
    }
    private func scale(){
        
    }
    
    private func updateUI(){
      //MARK: Make sure I create a variable to combine sunriseTime and sunseTime
        
        detailView.dayLabel.text = dayForecast?.sunriseTime.convertDate()
        detailView.summaryLabel.text = "Summary: \(dayForecast?.summary)"
        detailView.lowTempLabel.text = "Low: \(dayForecast?.temperatureLow ?? 0)"
        detailView.highTempLabel.text = "High: \(dayForecast?.temperatureHigh ?? 0)"
        detailView.sunriseLabel.text = "Sunrise: \(dayForecast?.sunriseTime.convertTime() ?? "")"
        detailView.sunsetLabel.text = "Sunset: \(dayForecast?.sunsetTime.convertTime() ?? "")"
        detailView.precipitationLabel.text = "\(dayForecast?.precipProbability ?? 0)% Chance of rain"
        detailView.windspeedLabel.text = "Wind: \(dayForecast?.windSpeed ?? 0)"
    
        
        detailView.imageView.getImage(with: picture?.largeImageURL ?? "") { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.detailView.imageView.image = UIImage(systemName: "sun.max")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.detailView.imageView.image = image
                    self?.picture = Picture(largeImageURL: self!.picture!.largeImageURL)
                }
                
            }
            
            
        }
    }
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonPress(_ :)))
    }
   @objc
    private func favoriteButtonPress(_ sender: UIBarButtonItem) {
    

    
    guard let image = detailView.imageView.image else {
        print("does not work !")
        return
    }
    //This is converting the image to data
    showAlert(title: "❤️", message: "This picture was added to your favorites")
    if let imageData = image.jpegData(compressionQuality: 0.5) {
        do {
            try persistenceHelper.create(item: ImageObject(image: imageData))
        } catch {
            print("unable to be saved \(error)")
        }
    }
    }
}

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
            
        }
    }
}
