//
//  PictureHitsModel.swift
//  WeatherApp
//
//  Created by Margiett Gil on 1/31/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import Foundation

struct PictureHits: Codable {
    let hits: [Picture]
}
struct Picture: Codable {
    let largeImageURL: String
}

