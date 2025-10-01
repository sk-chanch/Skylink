//
//  WeatherData.swift
//  Skylink
//
//  Created by MK-Mini on 8/9/2568 BE.
//

import Foundation
import CoreLocation

public struct WeatherData {
    public let temperature: Double
    public let condition: WeatherCondition
    public let humidity: Double
    public let windSpeed: Double
    public let pressure: Double
    public let uvIndex: Int?
    public let visibility: Double?
    
    public let location: String
    public let timestamp: Date
    public let forecastDaily: [DailyForecast]?
    public let forecastHourly: [HourlyForecast]?
    public let placemark: CLPlacemark?
    public let locale: Locale
    
    public let localizedCondition: String
    
    init(temperature: Double,
         condition: WeatherCondition,
         humidity: Double,
         windSpeed: Double,
         pressure: Double,
         uvIndex: Int?,
         visibility: Double?,
         location: String,
         timestamp: Date,
         forecastDaily: [DailyForecast]?,
         forecastHourly: [HourlyForecast]?,
         placemark: CLPlacemark?,
         locale: Locale) {
        self.temperature = temperature
        self.condition = condition
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.location = location
        self.timestamp = timestamp
        self.forecastDaily = forecastDaily
        self.forecastHourly = forecastHourly
        self.placemark = placemark
        self.locale = locale
        self.localizedCondition = condition.description(locale: locale)
    }
}


public struct DailyForecast {
    public let date: Date
    public let highTemperature: Double
    public let lowTemperature: Double
    public let condition: WeatherCondition
    public let precipitationChance: Double?
    public let sunriseTime: Date?
    public let sunsetTime: Date?
}

public struct HourlyForecast {
    public let time: Date
    public let temperature: Double
    public let condition: WeatherCondition
    public let precipitationChance: Double
}
