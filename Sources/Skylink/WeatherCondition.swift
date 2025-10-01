//
//  WeatherCondition.swift
//  WeatherDemo
//
//  Created by MK-Mini on 8/9/2568 BE.
//

import WeatherKit
import Foundation

public enum WeatherCondition: String, Codable {
    case clear
    case mostlyClear
    case partlyCloudy
    case mostlyCloudy
    case cloudy
    case rain
    case drizzle
    case sunShowers
    case thunderstorms
    case scatteredThunderstorms
    case isolatedThunderstorms
    case heavyRain
    case breezy
    case windy
    case hot
    case haze
    case smoky
    case unknown
    
    public var icon: String {
        switch self {
        case .clear:
            return "sun.max"
        case .mostlyClear:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun"
        case .mostlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud"
        case .rain:
            return "cloud.rain"
        case .drizzle:
            return "cloud.drizzle"
        case .sunShowers:
            return "cloud.sun.rain"
        case .thunderstorms:
            return "cloud.bolt.rain"
        case .scatteredThunderstorms:
            return "cloud.bolt.rain.fill"
        case .isolatedThunderstorms:
            return "cloud.bolt"
        case .heavyRain:
            return "cloud.heavyrain"
        case .breezy:
            return "wind"
        case .windy:
            return "wind"
        case .hot:
            return "thermometer.sun"
        case .haze:
            return "sun.haze"
        case .smoky:
            return "smoke"
        case .unknown:
            return "questionmark"
        }
    }
    
    public func description(locale: Locale = .current) -> String {
        var key = ""
        
        switch self {
        case .clear:
            key = "weather.condition.clear"
        case .mostlyClear:
            key = "weather.condition.mostlyClear"
        case .partlyCloudy:
            key = "weather.condition.partlyCloudy"
        case .mostlyCloudy:
            key = "weather.condition.mostlyCloudy"
        case .cloudy:
            key = "weather.condition.cloudy"
        case .rain:
            key = "weather.condition.rain"
        case .drizzle:
            key = "weather.condition.drizzle"
        case .sunShowers:
            key = "weather.condition.sunShowers"
        case .thunderstorms:
            key = "weather.condition.thunderstorms"
        case .scatteredThunderstorms:
            key = "weather.condition.scatteredThunderstorms"
        case .isolatedThunderstorms:
            key = "weather.condition.isolatedThunderstorms"
        case .heavyRain:
            key = "weather.condition.heavyRain"
        case .breezy:
            key = "weather.condition.breezy"
        case .windy:
            key = "weather.condition.windy"
        case .hot:
            key = "weather.condition.hot"
        case .haze:
            key = "weather.condition.haze"
        case .smoky:
            key = "weather.condition.smoky"
        default:
            key = "weather.condition.unknown"
        }
        
        return LocalizationHelper.localizedString(key, locale: locale)
    }
    
}

@available(iOS 16.0, *)
extension WeatherKit.WeatherCondition {
    func toWeatherDataCondition() -> WeatherCondition {
        switch self {
        case .clear:
            return .clear
        case .mostlyClear:
            return .mostlyClear
        case .partlyCloudy:
            return .partlyCloudy
        case .mostlyCloudy:
            return .mostlyCloudy
        case .cloudy:
            return .cloudy
        case .rain:
            return .rain
        case .drizzle:
            return .drizzle
        case .sunShowers:
            return .sunShowers
        case .thunderstorms:
            return .thunderstorms
        case .scatteredThunderstorms:
            return .scatteredThunderstorms
        case .isolatedThunderstorms:
            return .isolatedThunderstorms
        case .heavyRain:
            return .heavyRain
        case .breezy:
            return .breezy
        case .windy:
            return .windy
        case .hot:
            return .hot
        case .haze:
            return .haze
        case .smoky:
            return .smoky
        default:
            return .unknown
        }
    }
}
