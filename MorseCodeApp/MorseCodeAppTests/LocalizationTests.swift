//
//  LocalizationTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/7/31.
//

import XCTest
import MorseCodeApp

final class LocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Localizable"
        let bundle = Bundle(for: MorseCodePresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
