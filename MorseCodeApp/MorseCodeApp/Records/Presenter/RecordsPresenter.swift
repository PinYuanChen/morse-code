//
//  RecordsPresenter.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/30.
//

import MorseCode

public protocol RecordsPresenterDelegate: AnyObject {
    func reloadData()
    func showError(title: String?, message: String)
}

public class RecordsPresenter: MorseCodeConvertorPrototype {
    
    public weak var delegate: RecordsPresenterDelegate?
    public private(set) var records = [MorseRecord]()
    public var currentFlashStatus: FlashStatusType {
        get {
            flashManager.currentStatus
        }
    }
    public var flashManager: FlashManagerPrototype
    public let loader: MorseRecordLoaderPrototype
    
    public init(flashManager: FlashManagerPrototype,
                loader: MorseRecordLoaderPrototype) {
        self.flashManager = flashManager
        self.loader = loader
        
        self.flashManager.didFinishPlaying = { [unowned self] in
            self.delegate?.reloadData()
        }
    }
    
    public func loadRecords() async throws {
        do {
            records = try await loader.load() ?? []
            delegate?.reloadData()
        } catch {
            delegate?.showError(title: RecordsPresenter.alertTitle, message: RecordsPresenter.loadErrorMessage)
        }
    }
    
    public func deleteRecord(at index: Int) async throws {
        records.remove(at: index)
        do {
            try await loader.save(records)
            delegate?.reloadData()
        } catch {
            delegate?.showError(title: RecordsPresenter.alertTitle, message: RecordsPresenter.deleteErrorMessage)
        }
    }
    
    public func playOrPauseFlash(at index: Int, enableTorch: (() -> Bool) = FlashManager.enableTorch) {
        
        guard enableTorch() == true else {
            delegate?.showError(title: nil, message: MorseCodePresenter.torchAlertMessage)
            return
        }
        
        let record = records[index]
        if case .playing(id: let uuid) = flashManager.currentStatus {
            if uuid == record.id {
                flashManager.stopPlayingSignals()
            }
        } else {
            let signals = convertToMorseFlashSignals(input: record.morseCode)
            flashManager.startPlaySignals(signals: signals, uuid: record.id)
        }
        
        delegate?.reloadData()
    }
}

extension RecordsPresenter {
    static let alertTitle = NSLocalizedString("ALERT_TITLE", comment: "alert title")
    
    static let loadErrorMessage = NSLocalizedString("LOAD_ERROR_MESSAGE", comment: "fail to load records")
    
    static let deleteErrorMessage = NSLocalizedString("DELETE_ERROR_MESSAGE", comment: "fail to delete records")
}
