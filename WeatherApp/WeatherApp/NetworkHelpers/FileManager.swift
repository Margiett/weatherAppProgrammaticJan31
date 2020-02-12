//
//  FileManager.swift
//  WeatherApp
//
//  Created by Margiett Gil on 2/4/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    static func pathToDocumentsDirectory(with fileName: String) -> URL {
        
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
}
