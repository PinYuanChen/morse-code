//
//  TabBarItemType.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import Foundation

enum TabBarItemType: CaseIterable {
    case flash
    case records
    
    var title: String {
        switch self {
        case .flash:
            return NSLocalizedString("", comment: "")
        case .records:
            return NSLocalizedString("", comment: "")
        }
    }
    
    var image: String {
        switch self {
        case .flash:
            return "list.bullet.rectangle.portrait"
        case .records:
            return "clock"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .flash:
            return "list.bullet.rectangle.portrait.fill"
        case .records:
            return "clock.fill"
        }
    }
}
