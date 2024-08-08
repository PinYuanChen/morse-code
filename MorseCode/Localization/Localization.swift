//
//  Localization.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/8/8.
//

import Foundation

public class Localization {
    
    private static var bundle: Bundle = {
        Bundle(for: Localization.self)
    }()
    
    public static func string(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
    
    private init() { }
}
