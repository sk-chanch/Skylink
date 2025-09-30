//
//  Skylink.swift
//  Skylink
//
//  Created by MK-Mini on 8/9/2568 BE.
//

// MARK: - Service Factory
public actor Skylink {
    public static func create(provider: WeatherServiceProvider) throws -> WeatherAdapter {
        switch provider {
        case .native:
            return try createNativeAdapter()
        case .openWeather(let apiKey):
            return OpenWeatherAdapter(apiKey: apiKey)
        case .tmdWeather(let apiKey):
            return TMDWeatherAdapter(apiKey: apiKey)
        }
    }
    
    private static func createNativeAdapter() throws -> WeatherAdapter {
        if #available(iOS 16.0, *) {
            return NativeWeatherAdapter()
        } else {
            throw SkylinkError.unsupportedPlatform("Native WeatherKit requires iOS 16.0 or later")
        }
    }
    
    public static func createDefault(fallbackAPIKey: String) -> WeatherAdapter {
        if #available(iOS 16.0, *) {
            return NativeWeatherAdapter()
        } else {
            return OpenWeatherAdapter(apiKey: fallbackAPIKey)
        }
    }
}
