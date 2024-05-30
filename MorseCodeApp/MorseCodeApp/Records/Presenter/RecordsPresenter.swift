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

public class RecordsPresenter: MorseCodeConvertorPrototype {
    
    public weak var delegate: RecordsPresenterDelegate?
    public private(set) var records = [MorseRecord]()
    public private(set) var currentPlayingIndex: Int?
    public var flashManager: FlashManagerPrototype
    public let loader: MorseRecordLoaderPrototype
    
    public init(flashManager: FlashManagerPrototype,
                loader: MorseRecordLoaderPrototype) {
        self.flashManager = flashManager
        self.loader = loader
        
        self.flashManager.didFinishPlaying = { [unowned self] in
            self.currentPlayingIndex = nil
            self.delegate?.reloadData()
        }
    }
    
    public func loadRecords() async throws {
        do {
            records = try await loader.load() ?? []
            delegate?.reloadData()
        } catch {
            delegate?.showError(title: RecordsPresenter.loadErrorTitle, message: RecordsPresenter.loadErrorMessage)
        }
    }
    
    public func deleteRecord(at index: Int) async throws {
        records.remove(at: index)
        do {
            try await loader.save(records)
            delegate?.reloadData()
        } catch {
            delegate?.showError(title: RecordsPresenter.deleteErrorTitle, message: RecordsPresenter.deleteErrorMessage)
        }
    }
    
    public func playOrPauseFlash(at index: Int, enableTorch: (() -> Bool) = FlashManager.enableTorch) {
        
        guard enableTorch() == true else {
            delegate?.showError(title: MorseCodePresenter.torchAlertTitle, message: MorseCodePresenter.torchAlertMessage)
            return
        }
        
        if currentPlayingIndex == index {
            flashManager.stopPlayingSignals()
            currentPlayingIndex = nil
        } else {
            let morseCode = records[index].morseCode
            let signals = convertToMorseFlashSignals(input: morseCode)
            flashManager.startPlaySignals(signals: signals)
            currentPlayingIndex = index
        }
        
        delegate?.reloadData()
    }
}

extension RecordsPresenter {
    static let loadErrorTitle = NSLocalizedString("LOAD_ERROR_TITLE", comment: "fail to load records")
    
    static let loadErrorMessage = NSLocalizedString("LOAD_ERROR_MESSAGE", comment: "fail to load records")
    
    static let deleteErrorTitle = NSLocalizedString("DELETE_ERROR_TITLE", comment: "fail to delete records")
    
    static let deleteErrorMessage = NSLocalizedString("DELETE_ERROR_MESSAGE", comment: "fail to delete records")
}
