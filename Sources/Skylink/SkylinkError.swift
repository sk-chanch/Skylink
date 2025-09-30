//
//  SkylinkError.swift
//  Skylink
//
//  Created by MK-Mini on 30/9/2568 BE.
//

// MARK - Custom Error
public  enum SkylinkError: Error {
    case unsupportedPlatform(String)
    case invalidAPIKey
    case networkError(Error)
    case decodingError(Error)
    
    public var localizedDescription: String {
        switch self {
        case .unsupportedPlatform(let message):
            return message
        case .invalidAPIKey:
            return "Invalid API key provided"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}
