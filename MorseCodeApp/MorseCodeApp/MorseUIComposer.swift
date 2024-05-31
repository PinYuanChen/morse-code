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
    
    public static func composeMorseCode(with loader: MorseRecordLoaderPrototype, flashManager: FlashManagerPrototype) -> MorseCodeViewController {
        let presenter = MorseCodePresenter(flashManager: flashManager, localLoader: loader)
        
        let morseCodeViewController = MorseCodeViewController(presenter: presenter)
        
        morseCodeViewController.tabBarItem = MainTabBarItem(.main)
        return morseCodeViewController
    }
    
    public static func composeRecords(with loader: MorseRecordLoaderPrototype, flashManager: FlashManagerPrototype) -> RecordsViewController {
        let presenter = RecordsPresenter(flashManager: flashManager,loader: loader)
        
        let recordsViewController = RecordsViewController(presenter: presenter)
        recordsViewController.tabBarItem = MainTabBarItem(.records)
        return recordsViewController
    }
}

