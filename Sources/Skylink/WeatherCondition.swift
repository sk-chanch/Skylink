//
//  WeatherCondition.swift
//  WeatherDemo
//
//  Created by MK-Mini on 8/9/2568 BE.
//

import WeatherKit

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
    
    public var description: String {
        switch self {
        case .clear:
            return "ท้องฟ้าแจ่มใส"
        case .mostlyClear:
            return "ท้องฟ้าแจ่มใสเป็นส่วนใหญ่"
        case .partlyCloudy:
            return "มีเมฆบางส่วน"
        case .mostlyCloudy:
            return "เมฆมาก"
        case .cloudy:
            return "เมฆปกคลุม"
        case .rain:
            return "ฝนตก"
        case .drizzle:
            return "ฝนโปรย"
        case .sunShowers:
            return "ฝนตกแต่มีแดด"
        case .thunderstorms:
            return "ฝนฟ้าคะนอง"
        case .scatteredThunderstorms:
            return "ฝนฟ้าคะนองกระจาย"
        case .isolatedThunderstorms:
            return "ฝนฟ้าคะนองบางพื้นที่"
        case .heavyRain:
            return "ฝนตกหนัก"
        case .breezy:
            return "ลมเบา–ปานกลาง"
        case .windy:
            return "ลมแรง"
        case .hot:
            return "อากาศร้อน"
        case .haze:
            return "หมอกควัน / ฝุ่นละออง"
        case .smoky:
            return "ควันไฟหรือหมอกควัน"
        case .unknown:
            return "ไม่ทราบ"
        }
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
