//
// Created on 2024/1/11.
//

import UIKit

enum TabBarItemType: CaseIterable {
    case flash
    case about
    
    var title: String {
        switch self {
        case .flash:
            return NSLocalizedString("", comment: "")
        case .about:
            return NSLocalizedString("", comment: "")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .flash:
            return .init(systemName: "list.bullet.rectangle.portrait")
        case .about:
            return .init(systemName: "info.circle")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .flash:
            return .init(systemName: "list.bullet.rectangle.portrait.fill")
        case .about:
            return .init(systemName: "info.circle.fill")
        }
    }
}

