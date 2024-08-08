//
//  TabBarItemType.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import Foundation
import MorseCode

enum TabBarItemType: CaseIterable {
    case convert
    case table
    case records
    
    var title: String {
        switch self {
        case .convert:
            return Localization.string("CONVERT", comment: "")
        case .table:
            return Localization.string("TABLE", comment: "")
        case .records:
            return Localization.string("RECORDS", comment: "")
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
