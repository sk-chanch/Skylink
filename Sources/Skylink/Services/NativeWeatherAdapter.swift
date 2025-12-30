//
//  NativeWeatherAdapter.swift
//  Skylink
//
//  Created by MK-Mini on 8/9/2568 BE.
//

import WeatherKit
import CoreLocation


@available(iOS 16.0, *)
actor NativeWeatherAdapter: WeatherAdapter {
    private let weatherService = WeatherKit.WeatherService.shared
    private let configuration: SkylinkConfiguration
    
    init(configuration: SkylinkConfiguration) {
        self.configuration = configuration
    }
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            let weather = try await weatherService.weather(for: location)
            return await convertWeatherData(from: weather, location: location)
        } catch let error as NSError {
            print("❌ Error Domain: \(error.domain)")
            print("❌ Error Code: \(error.code)")
            print("❌ Error: \(error)")
            
            if error.code == 2 {
                print("Please allow App Services in Certificates, Identifiers & Profiles or disable proxy settings")
            }
            
            throw error
        }
    }
}

@available(iOS 16.0, *)
extension NativeWeatherAdapter {
   
    func convertWeatherData(from weatherData: WeatherKit.Weather, location: CLLocation) async -> WeatherData {
        let currentWeather = weatherData.currentWeather
        let (placeName, placemark) = await getLocationName(from: location, locale: configuration.local)
        
        let hourlyInCurrentDay = weatherData.hourlyForecast.forecast.filter{
            return Calendar.current.isDateInToday($0.date)
        }
        
        let minTemp = hourlyInCurrentDay.map { $0.temperature.value }.min()
        let maxTemp = hourlyInCurrentDay.map { $0.temperature.value }.max()
        
        let fealLike =  feelsLikeCelsius(tempC: currentWeather.temperature.value,
                                         humidity: currentWeather.humidity,
                                         windSpeed: currentWeather.wind.speed.value)
        
        return .init(temperature: currentWeather.temperature.value,
                     tempMin: minTemp,
                     tempMax: maxTemp,
                     feelsLike: fealLike,
                     condition: currentWeather.condition.toWeatherDataCondition(),
                     humidity: currentWeather.humidity,
                     windSpeed: currentWeather.wind.speed.value,
                     pressure: currentWeather.pressure.value,
                     uvIndex: currentWeather.uvIndex.value,
                     visibility: currentWeather.visibility.value,
                     location: placeName,
                     timestamp: weatherData.currentWeather.date,
                     forecastDaily: mapDailyForecast(weatherData.dailyForecast),
                     forecastHourly: mapHourlyForecast(weatherData.hourlyForecast),
                     placemark: placemark,
                     locale: configuration.local)
    }
    
    private func mapDailyForecast(_ forecast: Forecast<DayWeather>) -> [DailyForecast] {
        return forecast.forecast.map { dayWeather in
            DailyForecast(
                date: dayWeather.date,
                highTemperature: dayWeather.highTemperature.value,
                lowTemperature: dayWeather.lowTemperature.value,
                condition: dayWeather.condition.toWeatherDataCondition(),
                precipitationChance: dayWeather.precipitationChance,
                sunriseTime: dayWeather.sun.sunrise,
                sunsetTime: dayWeather.sun.sunset
            )
        }
    }
    
    private func mapHourlyForecast(_ forecast: Forecast<HourWeather>) -> [HourlyForecast] {
        return forecast.forecast.map { hourWeather in
            HourlyForecast(
                time: hourWeather.date,
                temperature: hourWeather.temperature.value,
                condition: hourWeather.condition.toWeatherDataCondition(),
                precipitationChance: hourWeather.precipitationChance
            )
        }
    }
    
    private func feelsLikeCelsius(tempC: Double, humidity: Double, windSpeed: Double) -> Double {
        // calculate vapor in hPa
        let e = humidity * 6.105 * exp((17.27 * tempC) / (237.7 + tempC))
        
        // calculate apparent temperature
        let feelsLike = tempC + 0.33 * e - 0.70 * windSpeed - 4.0
        
        return feelsLike
    }
}
