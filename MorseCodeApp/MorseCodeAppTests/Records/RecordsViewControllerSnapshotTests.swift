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
        let (sut, _) = makeSUT()

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "RecordsViewController_empty_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "RecordsViewController_empty_dark")
    }
    
    func test_nonEmptyRecordsUI() {
        let (sut, loader) = makeSUT()
        sut.presenter.loadRecords()
        loader.completeLoading(with: [anyRecord(), anyRecord()])
        sut.loadViewIfNeeded()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "RecordsViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "RecordsViewController_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (sut: RecordsViewController, loader: LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let viewController = MorseUIComposer.composeRecords(convertor: MorseConvertor(), loader: loaderSpy, flashManager: FlashManager())
        return (viewController, loaderSpy)
    }
}
