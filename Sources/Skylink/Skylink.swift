//
//  Skylink.swift
//  Skylink
//
//  Created by MK-Mini on 8/9/2568 BE.
//

// MARK: - Service Factory
public actor Skylink {
    public static func create(provider: WeatherServiceProvider,
                              configuration: SkylinkConfiguration = .init()) throws -> WeatherAdapter {
        switch provider {
        case .native:
            return try createNativeAdapter(configuration: configuration)
        case .openWeather(let apiKey):
            return OpenWeatherAdapter(apiKey: apiKey, configuration: configuration)
        case .tmdWeather(let apiKey):
            return TMDWeatherAdapter(apiKey: apiKey, configuration: configuration)
        }
    }
    
    private static func createNativeAdapter(configuration: SkylinkConfiguration) throws -> WeatherAdapter {
        if #available(iOS 16.0, *) {
            return NativeWeatherAdapter(configuration: configuration)
        } else {
            throw SkylinkError.unsupportedPlatform("Native WeatherKit requires iOS 16.0 or later")
        }
    }
    
    public static func createDefault(fallbackAPIKey: String, configuration: SkylinkConfiguration) -> WeatherAdapter {
        if #available(iOS 16.0, *) {
            return NativeWeatherAdapter(configuration: configuration)
        } else {
            return OpenWeatherAdapter(apiKey: fallbackAPIKey, configuration: configuration)
        }
    }
}
