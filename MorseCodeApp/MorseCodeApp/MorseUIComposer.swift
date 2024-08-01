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
    
    public static func composeMorseCode(convertor: MorseCodeConvertorPrototype, loader: MorseRecordLoaderPrototype, flashManager: FlashManagerPrototype) -> MorseCodeViewController {
        let presenter = MorseCodePresenter(convertor: convertor, flashManager: flashManager, localLoader: loader)
        
        let morseCodeViewController = MorseCodeViewController(presenter: presenter)
        presenter.delegate = morseCodeViewController
        
        morseCodeViewController.tabBarItem = MainTabBarItem(.main)
        return morseCodeViewController
    }
    
    public static func composeRecords(convertor: MorseCodeConvertorPrototype, loader: MorseRecordLoaderPrototype, flashManager: FlashManagerPrototype) -> RecordsViewController {
        let presenter = RecordsPresenter(convertor: convertor, flashManager: flashManager, loader: loader)
        
        let recordsViewController = RecordsViewController(presenter: presenter)
        presenter.delegate = recordsViewController
        
        recordsViewController.tabBarItem = MainTabBarItem(.records)
        return recordsViewController
    }
}

