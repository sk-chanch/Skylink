//
//  OpenWeatherCurrentResponse.swift
//  WeatherDemo
//
//  Created by MK-Mini on 8/9/2568 BE.
//

struct OpenWeatherCurrentResponse: Decodable {
    let coord: OpenWeatherCoord
    let weather: [OpenWeatherCondition]
    let base: String
    let main: OpenWeatherMain
    let visibility: Int
    let wind: OpenWeatherWind
    let rain: OpenWeatherRain?
    let clouds: OpenWeatherClouds
    let dt: Int
    let sys: OpenWeatherSys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct OpenWeatherCoord: Decodable {
    let lon: Double
    let lat: Double
}

struct OpenWeatherCondition: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct OpenWeatherMain: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct OpenWeatherWind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct OpenWeatherRain: Decodable {
    let oneHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct OpenWeatherClouds: Decodable {
    let all: Int
}

struct OpenWeatherSys: Decodable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

// MARK: - OpenWeatherMap Forecast API Response Models

struct OpenWeatherForecastResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [OpenWeatherForecastItem]
    let city: OpenWeatherCity
}

struct OpenWeatherForecastItem: Decodable {
    let dt: Int
    let main: OpenWeatherMain
    let weather: [OpenWeatherCondition]
    let clouds: OpenWeatherClouds
    let wind: OpenWeatherWind
    let visibility: Int
    let pop: Double? // rain change (0-1)
    let rain: OpenWeatherRain?
    let sys: OpenWeatherForecastSys?
    let dt_txt: String
}

struct OpenWeatherForecastSys: Decodable {
    let pod: String // part of day (n - night, d - day)
}

struct OpenWeatherCity: Decodable {
    let id: Int
    let name: String
    let coord: OpenWeatherCoord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
