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
    func test_recordsUI() async throws {
        let sut = makeSUT()
        
        try? await sut.presenter.loadRecords()
        await sut.loadViewIfNeeded()
        await assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "RecordsViewController_light")
        await assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "RecordsViewController_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> RecordsViewController {
        let loaderSpy = LoaderSpy()
        loaderSpy.completeLoadingWith([anyRecord(), anyRecord()])
        let viewController = MorseUIComposer.composeRecords(with: loaderSpy, flashManager: FlashManager())
        return viewController
    }
}
