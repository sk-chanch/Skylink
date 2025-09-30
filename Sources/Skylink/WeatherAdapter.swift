//
//  WeatherService.swift
//  Skylink
//
//  Created by MK-Mini on 30/9/2568 BE.
//

import CoreLocation

public protocol WeatherAdapter {
    func fetchWeather(for location: CLLocation) async throws -> WeatherData
    func getLocationName(from location: CLLocation) async -> String
}

public extension WeatherAdapter {
    func getLocationName(from location: CLLocation) async -> String {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                // create place name from placemark
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                return [locality, administrativeArea].filter { !$0.isEmpty }.joined(separator: ", ")
            }
        } catch {
            print("Geocoding error: \(error)")
        }
        
        return "Unknown Location"
    }
}
