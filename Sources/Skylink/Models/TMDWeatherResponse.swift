//
//  TMDWeatherResponse.swift
//  Skylink
//
//  Created by MK-Mini on 30/9/2568 BE.
//

import Foundation

// Main structure
struct TMDWeatherResponse: Codable {
    let weatherForecasts: [WeatherForecast]
    
    enum CodingKeys: String, CodingKey {
        case weatherForecasts = "WeatherForecasts"
    }
    
    // Weather forecast for a specific location
    struct WeatherForecast: Codable {
        let location: Location
        let forecasts: [Forecast]
    }

    // Location coordinates
    struct Location: Codable {
        let lat: Double
        let lon: Double
    }

    // Forecast for a specific time
    struct Forecast: Codable {
        let time: String
        let data: WeatherData
    }

    // Weather data details
    struct WeatherData: Codable {
        let cloudhigh: Double
        let cloudlow: Double
        let cloudmed: Double
        let cond: Int
        let rain: Double
        let rh: Double
        let slp: Double
        let swdown: Double
        let tc: Double
        let tcMax: Double?
        let tcMin: Double?
        let wd10m: Double
        let ws10m: Double
        
        enum CodingKeys: String, CodingKey {
            case cloudhigh = "cloudhigh"
            case cloudlow = "cloudlow"
            case cloudmed = "cloudmed"
            case cond = "cond"
            case rain = "rain"
            case rh = "rh"
            case slp = "slp"
            case swdown = "swdown"
            case tc = "tc"
            case tcMax = "tc_max"
            case tcMin = "tc_min"
            case wd10m = "wd10m"
            case ws10m = "ws10m"
        }
    }
}
