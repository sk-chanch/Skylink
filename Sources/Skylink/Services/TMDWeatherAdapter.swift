//
//  TMDWeatherAdapter.swift
//  Skylink
//
//  Created by MK-Mini on 30/9/2568 BE.
//

import CoreLocation

actor TMDWeatherAdapter: WeatherAdapter {
    private let apiKey: String
    private let baseURL = "https://data.tmd.go.th/nwpapi/v1/forecast/location"
                                                                      
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        let hourlyWeatherURL = URL(string:"\(baseURL)/hourly/at?"
            .appending("lat=\(location.coordinate.latitude)")
            .appending("&lon=\(location.coordinate.longitude)")
            .appending("&fields=tc,rh,slp,rain,ws10m,wd10m,cloudmed,cloudhigh,cond,cloudlow,swdown,tc_max,tc_min")
            .appending("&duration=24"))!
        
        let dailyWeatherURL = URL(string: "\(baseURL)/daily/at?"
            .appending("lat=\(location.coordinate.latitude)")
            .appending("&lon=\(location.coordinate.longitude)")
            .appending("&fields=tc,rh,slp,rain,ws10m,wd10m,cloudmed,cloudhigh,cond,cloudlow,swdown,tc_max,tc_min")
            .appending("&duration=7"))!
        
        var hourlyWeatherRequest = URLRequest(url: hourlyWeatherURL)
        hourlyWeatherRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "authorization")
        
        var dailyWeatherRequest = URLRequest(url: dailyWeatherURL)
        dailyWeatherRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "authorization")
        
        // fetch data parallel
        async let (hourlyWeatherData, _) = URLSession.shared.data(for: hourlyWeatherRequest)
        async let (dailyWeatherData, _) = URLSession.shared.data(for: dailyWeatherRequest)
        
        // wait all data
        let (hourlyData, dailyData) = try await (hourlyWeatherData, dailyWeatherData)
        
        let decoder = JSONDecoder()
        
        // convert json to model
        let hourlyWeatherResponse = try decoder.decode(TMDWeatherResponse.self, from: hourlyData)
        let dailyWeatherResponse = try decoder.decode(TMDWeatherResponse.self, from: dailyData)
        
        // convert to WeatherData
        return await convertToWeatherData(hourlyWeather: hourlyWeatherResponse,
                                          dailyWeather: dailyWeatherResponse,
                                          location: location)
    }
    
    private func convertToWeatherData(hourlyWeather: TMDWeatherResponse,
                                      dailyWeather: TMDWeatherResponse,
                                      location: CLLocation) async -> WeatherData {
        // create location name
        let locationName = await getLocationName(from: location)
        
        // convert forecast list to hourly forecasts
        let hourlyForecasts = hourlyWeather.weatherForecasts.first?.forecasts.map { item in
            HourlyForecast(time: convertDateTime(item.time),
                           temperature: item.data.tc,
                           condition: mapWeatherCondition(item.data.cond),
                           precipitationChance: 0)
        }
        
        let dailyForecasts = createDailyForecasts(from: dailyWeather.weatherForecasts.first?.forecasts)
        
        // create WeatherData from current weather
        let currentWeather = WeatherData(
            temperature: hourlyWeather.weatherForecasts.first?.forecasts.first?.data.tc ?? 0,
            condition: mapWeatherCondition(hourlyWeather.weatherForecasts.first?.forecasts.first?.data.cond ?? 0),
            humidity: (hourlyWeather.weatherForecasts.first?.forecasts.first?.data.rh ?? 0) / 100.0,
            windSpeed: hourlyWeather.weatherForecasts.first?.forecasts.first?.data.ws10m ?? 0,
            pressure: hourlyWeather.weatherForecasts.first?.forecasts.first?.data.slp ?? 0,
            uvIndex: nil,
            visibility: nil,
            location: locationName,
            timestamp: convertDateTime(hourlyWeather.weatherForecasts.first?.forecasts.first?.time),
            forecastDaily: dailyForecasts,
            forecastHourly: hourlyForecasts
        )
        
        return currentWeather
    }
    
    private func createDailyForecasts(from forecastList: [TMDWeatherResponse.Forecast]?) -> [DailyForecast] {
        return forecastList?.map { item in
            DailyForecast(
                date: convertDateTime(item.time),
                highTemperature: item.data.tcMax ?? 0,
                lowTemperature: item.data.tcMin ?? 0,
                condition: mapWeatherCondition(item.data.cond),
                precipitationChance: item.data.rain,
                sunriseTime: nil,
                sunsetTime: nil
            )
        } ?? []
    }
    
    private func mapWeatherCondition(_ id: Int) -> WeatherCondition {
//        1 = ท้องฟ้าแจ่มใส (Clear)
//        2 = มีเมฆบางส่วน (Partly cloudy)
//        3 = เมฆเป็นส่วนมาก (Cloudy)
//        4 = มีเมฆมาก (Overcast)
//        5 = ฝนตกเล็กน้อย (Light rain)
//        6 = ฝนปานกลาง (Moderate rain)
//        7 = ฝนตกหนัก (Heavy rain)
//        8 = ฝนฟ้าคะนอง (Thunderstorm)
//        9 = อากาศหนาวจัด (Very cold)
//        10 = อากาศหนาว (Cold)
//        11 = อากาศเย็น (Cool)
//        12 = อากาศร้อนจัด (Very hot)
        
        switch id {
        case 1:
            return .clear
        case 2:
            return .mostlyClear
        case 3:
            return .partlyCloudy
        case 4:
            return .mostlyCloudy
        case 5:
            return .rain
        case 6:
            return .drizzle
        case 7:
            return .sunShowers
        case 8:
            return .thunderstorms
        case 12:
            return .hot
        default:
            return .unknown
        }
    }
    
    private func convertDateTime(_ dateString: String?) -> Date {
        guard let dateString = dateString else {
            return .init()
        }
        
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone,
            .withDashSeparatorInDate,
            .withFullTime
        ]
        
        return iso8601Formatter.date(from: dateString) ?? .init()
    }
}
