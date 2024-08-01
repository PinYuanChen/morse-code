//
//  LoaderSpy.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/5/28.
//

import MorseCode
import MorseCodeApp

final class LoaderSpy: MorseRecordLoaderPrototype {
    
    enum ReceivedMessage: Equatable {
        case load
        case save(records: [MorseRecord])
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var saveCompletions = [SaveCompletion]()
    private var loadCompletions = [LoadCompletion]()
    var records = [MorseRecord]()
    
    func save(_ records: [MorseRecord], completion: @escaping SaveCompletion) {
        saveCompletions.append(completion)
        receivedMessages.append(.save(records: records))
    }
    
    func completeSaving(with error: Error, at index: Int = 0) {
        saveCompletions[index](.failure(error))
    }
    
    func completeSavingSuccessfully(at index: Int = 0) {
        saveCompletions[index](.success(()))
    }
    
    func load(completion: @escaping LoadCompletion) {
        loadCompletions.append(completion)
        receivedMessages.append(.load)
    }
    
    func completeLoading(with error: Error, at index: Int = 0) {
        loadCompletions[index](.failure(error))
    }
    
    func completeLoading(with records: [MorseRecord], at index: Int = 0) {
        loadCompletions[index](.success(records))
    }
}
