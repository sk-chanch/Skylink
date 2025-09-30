//
//  WeatherServiceProvider.swift
//  Skylink
//
//  Created by MK-Mini on 30/9/2568 BE.
//

// MARK: - Service Provider Enum
public enum WeatherServiceProvider {
    case native
    case openWeather(apiKey: String)
}
