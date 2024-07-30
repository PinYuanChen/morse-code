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
    
    func test_loadRecordsUponRequest() {
        let (sut, loader) = makeSUT()
        sut.loadRecords()
        XCTAssertEqual(loader.receivedMessages, [.load])
    }
    
    func test_deleteRecords() {
        let (sut, loader) = makeSUT()
        sut.loadRecords()
        loader.completeLoading(with: [anyRecord()])
        
        sut.deleteRecord(at: 0)
        
        XCTAssertEqual(sut.records, [])
        XCTAssertEqual(loader.receivedMessages, [.load, .save(records: [])])
    }
    
    func test_doesNotPlaySignals_onInvalidDevice() {
        let (sut, loader) = makeSUT()
        sut.loadRecords()
        loader.completeLoading(with: [anyRecord()])
        
        sut.playOrPauseFlash(at: 0, enableTorch: { false })
        XCTAssertEqual(sut.currentFlashStatus, .stop)
    }
    
    func test_playAndPauseFlashSignals_onCorrectIndex() {
        let (sut, loader) = makeSUT()
        let record = anyRecord()
        sut.loadRecords()
        loader.completeLoading(with: [record])
        
        sut.playOrPauseFlash(at: 0, enableTorch: { true })
        XCTAssertEqual(sut.currentFlashStatus, .playing(id: record.id))
        sut.playOrPauseFlash(at: 0, enableTorch: { true })
        XCTAssertEqual(sut.currentFlashStatus, .stop)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RecordsPresenter, loader: LoaderSpy) {
        
        let loaderSpy = LoaderSpy()
        let sut = RecordsPresenter(convertor: MorseConvertor(), flashManager: FlashManager(), loader: loaderSpy)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        return (sut, loaderSpy)
    }
}
