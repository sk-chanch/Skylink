//
//  LocalizationHelper.swift
//  Skylink
//
//  Created by MK-Mini on 1/10/2568 BE.
//

import Foundation

struct LocalizationHelper {
    static func localizedString(
        _ key: String,
        locale: Locale = .current,
        comment: String = ""
    ) -> String {
        let bundle = Bundle.module
        
        // Try to get localized string for specific locale
        if let languageCode = locale.languageCode,
           let path = bundle.path(forResource: languageCode, ofType: "lproj"),
           let localizedBundle = Bundle(path: path) {
            let localizedString = NSLocalizedString(
                key,
                bundle: localizedBundle,
                comment: comment
            )
            // If translation exists, return it
            if localizedString != key {
                return localizedString
            }
        }
        
        if let path = bundle.path(forResource: locale.identifier, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: comment)
        }
        
        // Fallback to English
        if let path = bundle.path(forResource: "en", ofType: "lproj"),
           let englishBundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: englishBundle, comment: comment)
        }
        
        // Final fallback
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
}
