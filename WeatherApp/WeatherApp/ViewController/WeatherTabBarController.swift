//
//  WeatherTabBarController.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/5/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit

class WeatherTabBarController: UITabBarController {

   //MARK: This Code right here is adding the tabbar programticly
       private lazy var weatherSearchVC: WeatherSearchController = {
           
        let viewController = WeatherSearchController()
           
        viewController.tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "weather"), tag: 0)
           
        return viewController
       }()
       
       private lazy var faveVC: FavoritesViewController = {
            
        let viewController = FavoritesViewController()
             
        viewController.tabBarItem = UITabBarItem(title: "Fave", image: UIImage(systemName: "heart.fill"), tag: 1)
             
        return viewController
         }()
       

       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .systemBackground
           //MARK: This is what is actually making the tabs show.
           viewControllers = [UINavigationController(rootViewController: weatherSearchVC), UINavigationController(rootViewController: faveVC)]
        
       }
       

}
