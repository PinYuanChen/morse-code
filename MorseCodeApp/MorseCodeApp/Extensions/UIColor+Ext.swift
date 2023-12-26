//
// Created on 2023/12/26.
//

import UIKit

extension UIColor {
    private static func color(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
    /// vc background
    static let bg04121F: UIColor = #colorLiteral(red: 0.01568627451, green: 0.07058823529, blue: 0.1215686275, alpha: 1)
    
    /// title color
    static let txt5BC5A5: UIColor = #colorLiteral(red: 0.3568627451, green: 0.7725490196, blue: 0.6470588235, alpha: 1)
    
    /// base info view
    static let bg25333F: UIColor = #colorLiteral(red: 0.1450980392, green: 0.2, blue: 0.2470588235, alpha: 1)
    
    /// input bg color
    static let bg1B262F: UIColor = #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1843137255, alpha: 1)
    
    /// input view line
    static let line3A4955: UIColor = #colorLiteral(red: 0.2274509804, green: 0.2862745098, blue: 0.3333333333, alpha: 1)
    
    /// green border line
    static let line69E2C1: UIColor = #colorLiteral(red: 0.4117647059, green: 0.8862745098, blue: 0.7568627451, alpha: 1)
    
    /// convert button gradient background
    static let bg275452: UIColor = #colorLiteral(red: 0.1529411765, green: 0.3294117647, blue: 0.3215686275, alpha: 1)
    
    /// convert button gradient background
    static let bg1F4343: UIColor = #colorLiteral(red: 0.1215686275, green: 0.262745098, blue: 0.262745098, alpha: 1)
}
