//
//  RecordsPresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/30.
//

import MorseCode

public protocol RecordsPresenterDelegate: AnyObject {
    func reloadData()
    func showError(title: String, message: String)
}

public class RecordsPresenter {
    
    public weak var delegate: RecordsPresenterDelegate?
    public private(set) var records = [MorseRecord]()
    public let loader: MorseRecordLoaderPrototype
    
    public init(loader: MorseRecordLoaderPrototype) {
        self.loader = loader
    }
    
    public func loadRecords() async throws {
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
