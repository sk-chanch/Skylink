//
//  OpenWeatherAdapter.swift
//  Skylink
//
//  Created by MK-Mini on 8/9/2568 BE.
//

import CoreLocation

actor OpenWeatherAdapter: WeatherAdapter {
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5"
                                                                      
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        // create URL for current weather
        let currentWeatherURL = URL(string: "\(baseURL)/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)")!
        
        // create URL for forecast
        let forecastURL = URL(string: "\(baseURL)/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)")!
        
        // fetch data parallel
        async let (currentWeatherData, _) = URLSession.shared.data(from: currentWeatherURL)
        async let (forecastData, _) = URLSession.shared.data(from: forecastURL)
        
        // wait all data
        let (currentData, forecastResponseData) = try await (currentWeatherData, forecastData)
        
        // convert json to model
        let currentWeatherResponse = try JSONDecoder().decode(OpenWeatherCurrentResponse.self, from: currentData)
        let forecastResponse = try JSONDecoder().decode(OpenWeatherForecastResponse.self, from: forecastResponseData)
        
        // convert to WeatherData
        return convertToWeatherData(currentWeather: currentWeatherResponse, forecast: forecastResponse)
    }
    
    private func convertToWeatherData(currentWeather: OpenWeatherCurrentResponse, forecast: OpenWeatherForecastResponse) -> WeatherData {
        // create location name
        let locationName = currentWeather.name + (currentWeather.sys.country.isEmpty ? "" : ", \(currentWeather.sys.country)")
        
        // convert forecast list to hourly forecasts
        let hourlyForecasts = forecast.list.prefix(24).map { item in
            HourlyForecast(
                time: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                temperature: item.main.temp,
                condition: mapWeatherCondition(item.weather.first?.id ?? 0),
                precipitationChance: item.pop ?? 0
            )
        }
        
        // create daily forecasts
        let dailyForecasts = createDailyForecasts(from: forecast.list)
        
        // create WeatherData from current weather
        return WeatherData(
            temperature: currentWeather.main.temp,
            condition: mapWeatherCondition(currentWeather.weather.first?.id ?? 0),
            humidity: Double(currentWeather.main.humidity) / 100.0, // convert to percentage
            windSpeed: currentWeather.wind.speed,
            pressure: Double(currentWeather.main.pressure),
            uvIndex: 0, // Current Weather API ไม่มี UV Index
            visibility: Double(currentWeather.visibility) / 1000.0, // convert meter to kilometer
            location: locationName,
            timestamp: Date(timeIntervalSince1970: TimeInterval(currentWeather.dt)),
            forecastDaily: dailyForecasts,
            forecastHourly: hourlyForecasts
        )
    }
    
    private func mapWeatherCondition(_ id: Int) -> WeatherCondition {
        switch id {
        case 800:
            return .clear
        case 801...804:
            return id == 801 ? .partlyCloudy : .cloudy
        case 300...321:
            return .drizzle
        case 500...531:
            return .rain
        case 200...232:
            return .thunderstorms
        default:
            return .unknown
        }
    }
    
    private func createDailyForecasts(from forecastList: [OpenWeatherForecastItem]) -> [DailyForecast] {
        // group by day
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: forecastList) { item in
            calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(item.dt)))
        }
        
        // create daily forecasts
        return groupedByDay.map { date, items in
            // find high and low temperature
            let highTemp = items.map { $0.main.temp_max }.max() ?? 0
            let lowTemp = items.map { $0.main.temp_min }.min() ?? 0
            
            // find most common weather condition
            let conditions = items.compactMap { $0.weather.first?.id }
            let mostCommonCondition = conditions.max { a, b in
                conditions.filter { $0 == a }.count < conditions.filter { $0 == b }.count
            } ?? 0
            
            // find max precipitation chance
            let maxPrecipChance = items.compactMap { $0.pop }.max() ?? 0
            
            return DailyForecast(
                date: date,
                highTemperature: highTemp,
                lowTemperature: lowTemp,
                condition: mapWeatherCondition(mostCommonCondition),
                precipitationChance: maxPrecipChance,
                sunriseTime: nil, // use other api for sunrise and sunset
                sunsetTime: nil
            )
        }.sorted { $0.date < $1.date }
    }
}
