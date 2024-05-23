//
//  TabBarItemType.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import Foundation

enum TabBarItemType: CaseIterable {
    case main
    case records
    
    var title: String {
        switch self {
        case .main:
            return NSLocalizedString("MAIN", comment: "")
        case .records:
            return NSLocalizedString("RECORDS", comment: "")
        }
    }
    
    var image: String {
        switch self {
        case .main:
            return "list.bullet.rectangle.portrait"
        case .records:
            return "clock"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .main:
            return "list.bullet.rectangle.portrait.fill"
        case .records:
            return "clock.fill"
        }
    }
}
