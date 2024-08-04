//
//  TabBarItemType.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import Foundation

enum TabBarItemType: CaseIterable {
    case convert
    case records
    
    var title: String {
        switch self {
        case .convert:
            return NSLocalizedString("CONVERT", comment: "")
        case .records:
            return NSLocalizedString("RECORDS", comment: "")
        }
    }
    
    var image: String {
        switch self {
        case .convert:
            return "chevron.right.square"
        case .records:
            return "clock"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .convert:
            return "chevron.right.square.fill"
        case .records:
            return "clock.fill"
        }
    }
}
