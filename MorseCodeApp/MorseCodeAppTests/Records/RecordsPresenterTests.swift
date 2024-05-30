//
//  RecordsPresenterTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/30.
//

import XCTest
import MorseCode
import MorseCodeApp

final class RecordsPresenterTests: XCTestCase {
    func test_initDoesNotLoadRecords() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.records, [])
    }
    
    func test_loadRecordsUponRequest() async throws {
        let (sut, loader) = makeSUT()
        try await sut.loadRecords()
        XCTAssertEqual(loader.receivedMessages, [.load])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RecordsPresenter, loader: LoaderSpy) {
        
        let loaderSpy = LoaderSpy()
        let sut = RecordsPresenter(loader: loaderSpy)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        return (sut, loaderSpy)
    }
}
