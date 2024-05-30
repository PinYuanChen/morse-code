//
//  RecordsPresenterTests.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/30.
//

import XCTest
import MorseCode
import MorseCodeApp

protocol RecordsPresenterDelegate: AnyObject {
    func reloadData()
    func showError(title: String, message: String)
}

class RecordsPresenter {
    
    weak var delegate: RecordsPresenterDelegate?
    private(set) var records = [MorseRecord]()
    let loader: MorseRecordLoaderPrototype
    
    init(loader: MorseRecordLoaderPrototype) {
        self.loader = loader
    }
    
    func loadRecords() async throws {
        do {
            records = try await loader.load() ?? []
            delegate?.reloadData()
        } catch {
            delegate?.showError(title: RecordsPresenter.loadErrorTitle, message: RecordsPresenter.loadErrorMessage)
        }
    }
}

extension RecordsPresenter {
    static let loadErrorTitle = NSLocalizedString("LOAD_ERROR_TITLE", comment: "fail to load data")
    
    static let loadErrorMessage = NSLocalizedString("LOAD_ERROR_MESSAGE", comment: "fail to load data")
}

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
