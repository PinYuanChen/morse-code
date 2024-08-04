//
//  TabBarItemType.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import Foundation

enum TabBarItemType: CaseIterable {
    case convert
    case table
    case records
    
    var title: String {
        switch self {
        case .convert:
            return NSLocalizedString("CONVERT", comment: "")
        case .table:
            return NSLocalizedString("TABLE", comment: "")
        case .records:
            return NSLocalizedString("RECORDS", comment: "")
        }
    }
    
    var image: String {
        switch self {
        case .convert:
            return "chevron.right.square"
        case .table:
            return "list.bullet.rectangle.portrait"
        case .records:
            return "clock"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .convert:
            return "chevron.right.square.fill"
        case .table:
            return "list.bullet.rectangle.portrait.fill"
        case .records:
            return "clock.fill"
        }
    }
}
