//
//  WeatherService.swift
//  Skylink
//
//  Created by MK-Mini on 30/9/2568 BE.
//

import CoreLocation

public protocol WeatherAdapter {
    func fetchWeather(for location: CLLocation) async throws -> WeatherData
    func getLocationName(from location: CLLocation, locale: Locale) async -> (String, CLPlacemark?)
}

public extension WeatherAdapter {
    func getLocationName(from location: CLLocation, locale: Locale) async ->  (String, CLPlacemark?) {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: locale)
            if let placemark = placemarks.first {
                // create place name from placemark
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let placeName = [locality, administrativeArea].filter { !$0.isEmpty }.joined(separator: ", ")
                
                return (placeName, placemark)
            }
        } catch {
            print("Geocoding error: \(error)")
        }
        
        return ("Unknown Location", nil)
    }
}
