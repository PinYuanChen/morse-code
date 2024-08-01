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
        let (sut, _, _) = makeSUT()
        XCTAssertEqual(sut.records, [])
    }
    
    func test_loadRecordsUponRequest() {
        let (sut, loader, _) = makeSUT()
        sut.loadRecords()
        XCTAssertEqual(loader.receivedMessages, [.load])
    }
    
    func test_deleteRecordsUponRequest() {
        let (sut, loader, _) = makeSUT()
        sut.loadRecords()
        loader.completeLoading(with: [anyRecord()])
        
        sut.deleteRecord(at: 0)
        
        XCTAssertEqual(sut.records, [])
        XCTAssertEqual(loader.receivedMessages, [.load, .save(records: [])])
    }
    
    func test_deliverError_onLoadingFailure() {
        let (sut, loader, delegate) = makeSUT()
        sut.loadRecords()
        loader.completeLoading(with: anyNSError())
        
        XCTAssertEqual(delegate.receivedMessages, [.error(title: RecordsPresenter.alertTitle, message: RecordsPresenter.loadErrorMessage)])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RecordsPresenter, loader: LoaderSpy, delegate: ViewSpy) {
        
        let viewSpy = ViewSpy()
        let loaderSpy = LoaderSpy()
        let sut = RecordsPresenter(convertor: MorseConvertor(), flashManager: FlashManager(), loader: loaderSpy)
        sut.delegate = viewSpy
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        return (sut, loaderSpy, viewSpy)
    }
}
