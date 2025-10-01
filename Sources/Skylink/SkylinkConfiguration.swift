//
//  SkylinkConfiguration.swift
//  Skylink
//
//  Created by MK-Mini on 1/10/2568 BE.
//

import Foundation

public enum MeasurementSystemCompat {
    case metric
    case imperial
}

public struct SkylinkConfiguration {
    let local: Locale
    let temperatureUnit: UnitTemperature
    let measurementSystem: MeasurementSystemCompat
    
    public init(local: Locale = .current,
                temperatureUnit: UnitTemperature = .celsius,
                measurementSystem: MeasurementSystemCompat = .metric) {
        self.local = local
        self.temperatureUnit = temperatureUnit
        self.measurementSystem = measurementSystem
    }
    
    public init(local: Locale) {
        self.local = local
        self.temperatureUnit = .celsius
        self.measurementSystem = .metric
    }
}
