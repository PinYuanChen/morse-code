//
//  RecordsViewControllerSnapshotTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/7/25.
//

import XCTest
import MorseCode
import MorseCodeApp

final class RecordsViewControllerSnapshotTests: XCTestCase {
    func test_emptyRecordsUI() {
        let sut = makeSUT()

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "RecordsViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "RecordsViewController_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> RecordsViewController {
        let viewController = MorseUIComposer.composeRecords(convertor: MorseConvertor(), loader: LoaderSpy(), flashManager: FlashManager())
        return viewController
    }
}
