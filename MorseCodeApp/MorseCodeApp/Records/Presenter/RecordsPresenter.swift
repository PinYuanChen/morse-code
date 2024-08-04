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

public protocol RecordsPresenterPrototype {
    var delegate: RecordsPresenterDelegate? { get set }
    var records: [MorseRecord] { get }
    var currentFlashStatus: FlashStatusType { get }
    func loadRecords()
    func deleteRecord(at index: Int)
    func playOrPauseFlash(at index: Int)
}

public class RecordsPresenter: RecordsPresenterPrototype {
    
    public var delegate: RecordsPresenterDelegate?
    public private(set) var records = [MorseRecord]()
    public var currentFlashStatus: FlashStatusType {
        flashManager.currentStatus
    }
    public let convertor: MorseCodeConvertorPrototype
    public var flashManager: FlashManagerPrototype
    public let loader: MorseRecordLoaderPrototype
    
    public init(convertor: MorseCodeConvertorPrototype, flashManager: FlashManagerPrototype,
                loader: MorseRecordLoaderPrototype) {
        self.convertor = convertor
        self.flashManager = flashManager
        self.loader = loader
        
        self.flashManager.completePlayingHandlers.append ({ [unowned self] in
            self.delegate?.reloadData()
        })
    }
    
    public func loadRecords() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(records):
                self.records = records ?? []
                self.delegate?.reloadData()
            case .failure(_):
                self.delegate?.showError(title: RecordsPresenter.alertTitle, message: RecordsPresenter.loadErrorMessage)
            }
        }
    }
    
    public func deleteRecord(at index: Int) {
        records.remove(at: index)
        
        loader.save(records) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.reloadData()
            case .failure(_):
                self?.delegate?.showError(title: RecordsPresenter.alertTitle, message: RecordsPresenter.deleteErrorMessage)
            }
        }
    }
    
    public func playOrPauseFlash(at index: Int) {
        
        guard flashManager.enableTorch else {
            delegate?.showError(title: nil, message: MorseCodePresenter.torchAlertMessage)
            return
        }
        
        let record = records[index]
        if case .playing(id: let uuid) = flashManager.currentStatus {
            if uuid == record.id {
                flashManager.stopPlayingSignals()
            }
        } else {
            let signals = convertor.convertToMorseFlashSignals(input: record.morseCode)
            flashManager.startPlaySignals(signals: signals, uuid: record.id)
        }
        
        delegate?.reloadData()
    }
}

public extension RecordsPresenter {
    static let alertTitle = NSLocalizedString("ALERT_TITLE", comment: "alert title")
    
    static let loadErrorMessage = NSLocalizedString("LOAD_ERROR_MESSAGE", comment: "fail to load records")
    
    static let deleteErrorMessage = NSLocalizedString("DELETE_ERROR_MESSAGE", comment: "fail to delete records")
}
