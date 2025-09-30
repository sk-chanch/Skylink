//
//  WeatherData.swift
//  Skylink
//
//  Created by MK-Mini on 8/9/2568 BE.
//

import Foundation


public struct WeatherData {
    public let temperature: Double
    public let condition: WeatherCondition
    public let humidity: Double
    public let windSpeed: Double
    public let pressure: Double
    public let uvIndex: Int
    public let visibility: Double
    
    public let location: String
    public let timestamp: Date
    public let forecastDaily: [DailyForecast]?
    public let forecastHourly: [HourlyForecast]?
}


public struct DailyForecast {
    public let date: Date
    public let highTemperature: Double
    public let lowTemperature: Double
    public let condition: WeatherCondition
    public let precipitationChance: Double
    public let sunriseTime: Date?
    public let sunsetTime: Date?
}

public struct HourlyForecast {
    public let time: Date
    public let temperature: Double
    public let condition: WeatherCondition
    public let precipitationChance: Double
}
