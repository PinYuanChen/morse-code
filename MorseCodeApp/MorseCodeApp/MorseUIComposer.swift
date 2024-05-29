//
//  MorseUIComposer.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/29.
//

import UIKit
import MorseCode

final public class MorseUIComposer {
    private init() { }
    
    public static func composeMorseCode(with loader: MorseRecordLoaderPrototype) -> MorseCodeViewController {
        let flashManager = FlashManager()
        let presenter = MorseCodePresenter(flashManager: flashManager, localLoader: loader)
        
        let morseCodeViewController = MorseCodeViewController(presenter: presenter)
        
        morseCodeViewController.tabBarItem = MainTabBarItem(.main)
        return morseCodeViewController
    }
    
    public static func composeRecords() -> RecordsViewController {
        let recordsViewController = RecordsViewController()
        recordsViewController.tabBarItem = MainTabBarItem(.records)
        return recordsViewController
    }
}

