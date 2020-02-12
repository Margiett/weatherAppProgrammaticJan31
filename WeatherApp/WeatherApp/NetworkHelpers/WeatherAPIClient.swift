//
//  WeatherAPIClient.swift
//  WeatherApp January 31st
//
//  Created by Margiett Gil on 1/31/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import Foundation
import NetworkHelper

struct WeatherAPIClient {
    static func getWeather(lat: Double, long: Double, completion: @escaping (Result<[DailyForecast], AppError>) -> () ) {
        let endpointUrl = "https://api.darksky.net/forecast/8a1c17527d12ff945fc3851cc122d9e6/\(lat.description),\(long.description)"
        guard let url = URL(string: endpointUrl) else {
            completion(.failure(.badURL(endpointUrl)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(results.daily.data))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}

