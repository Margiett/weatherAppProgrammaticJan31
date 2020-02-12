//
//  userPreferenceKeys.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/4/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import Foundation

struct UserPreferenceKey {
    static let zipCode = "Zipcode"
   
}
class UserPreference {
    
    private init() {}
    
    static let shared = UserPreference()
    //MARK: saving to user default
    func updateZodiac(with zipCode: String) {
        UserDefaults.standard.set(zipCode, forKey: UserPreferenceKey.zipCode)
    
    }
//    func updatName(with name: String){
//        UserDefaults.standard.set(name, forKey: UserPreferenceKey.name)
//    }
    //MARK: we are retrieving the information from the user default
    func getZipcode() -> String? {
        guard let zip = UserDefaults.standard.object(forKey: UserPreferenceKey.zipCode) as? String else {
            return nil
        }
        return zip
    }
//    func getUserName() -> String? {
//        guard let userNameMar = UserDefaults.standard.object(forKey: UserPreferenceKey.name) as? String else {
//            return nil
//        }
//        return userNameMar
//    }
  
}

