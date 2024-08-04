//
//  MorseCodePresenterTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/15.
//

import XCTest
import MorseCode
import MorseCodeApp

public final class MorseCodePresenterTests: XCTestCase {
    
    func test_validateValidCharacters() {
        let (sut, _, _) = makeSUT()

        let validInput = validCharacters + validNumbers + validSigns
        validInput.forEach {
            XCTAssertTrue(sut.validateInput(string: $0))
        }
    }
    
    func test_validateInvalidCharacters() {
        let (sut, _, _) = makeSUT()
        
        let invalids = ["😎", "🥩", "卍", "中"]
        invalids.forEach {
            XCTAssertFalse(sut.validateInput(string: $0))
        }
        
    }
    
    func test_validateInputLength() {
        let (sut, _, _) = makeSUT()
        let maxLength = MorseCodePresenter.maxInputLength
        let currentText = String(repeating: "z", count: maxLength) as NSString
        
        XCTAssertFalse(sut.validateInput(string: "z", currentText: currentText, range: .init(location: maxLength, length: 0)))
    }
    
    func test_convertValidInputIntoMorseCode() {
        let (sut, _, _) = makeSUT()
        XCTAssertEqual(sut.convertToMorseCode(text: "sos"), sosMorseCodeString)
        XCTAssertEqual(sut.convertToMorseCode(text: "a123"), a123MorseCodeString)
        XCTAssertEqual(sut.convertToMorseCode(text: "Hello world!"), helloWorldMorseCodeString)
    }
    
    func test_presentedUUID_isSetAfterSaveToLocalStore() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertNil(sut.presentedUUID)
        
        let newRecord = anyRecord()
        sut.saveToLocalStore(newRecord: newRecord)
        
        XCTAssertEqual(newRecord.id, sut.presentedUUID)
    }
    
    func test_deliverError_onLoadingError() {
        let (sut, loader, delegate) = makeSUT()
        
        sut.saveToLocalStore(newRecord: anyRecord())
        loader.completeLoading(with: anyNSError())
        
        XCTAssertEqual(delegate.receivedMessages, [.error(title: MorseCodePresenter.alertTitle, message: MorseCodePresenter.saveErrorMessage)])
    }
    
    func test_deliverError_onSavingError() {
        let (sut, loader, delegate) = makeSUT()
        
        sut.saveToLocalStore(newRecord: anyRecord())
        loader.completeLoading(with: [])
        loader.completeSaving(with: anyNSError())
        
        XCTAssertEqual(delegate.receivedMessages, [.error(title: MorseCodePresenter.alertTitle, message: MorseCodePresenter.saveErrorMessage)])
    }
    
    func test_updateFlashStatus() {
        let (sut, _, delegate) = makeSUT()
        sut.getFlashButtonStatus()
        XCTAssertEqual(delegate.receivedMessages[0], .updateButton(status: .stop, enable: false))
        
        sut.saveToLocalStore(newRecord: anyRecord())
        sut.getFlashButtonStatus()
        XCTAssertEqual(delegate.receivedMessages[1], .updateButton(status: .stop, enable: true))
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: MorseCodePresenter, loader: LoaderSpy, delegate: ViewSpy) {
        
        let viewSpy = ViewSpy()
        let loaderSpy = LoaderSpy()
        
        let sut = MorseCodePresenter(convertor: MorseConvertor(), flashManager: FlashManager(), localLoader: loaderSpy)
        sut.delegate = viewSpy
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        return (sut, loaderSpy, viewSpy)
    }
    
    private let sosMorseCodeString = "... --- ... "
    private let a123MorseCodeString = ".- .---- ..--- ...-- "
    private let helloWorldMorseCodeString = ".... . .-.. .-.. ---    .-- --- .-. .-.. -.. -.-.-- "
}
