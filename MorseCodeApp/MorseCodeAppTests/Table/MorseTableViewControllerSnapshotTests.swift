//
//  MorseTableViewControllerSnapshotTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/8/4.
//

import XCTest
import MorseCode
import MorseCodeApp

final class MorseTableViewControllerSnapshotTests: XCTestCase {

    func test_morseTableUI() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "MorseTableViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "MorseTableViewController_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> MorseTableViewController {
        let viewController = MorseUIComposer.composeMorseTable(dataSource: validCharacters)
        return viewController
    }
}
