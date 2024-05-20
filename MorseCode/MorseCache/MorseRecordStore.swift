//
//  MorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public protocol MorseRecordStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedRecords(completion: @escaping DeletionCompletion)
    func insert(_ records: [LocalMorseRecord], completion: @escaping InsertionCompletion)
}

public struct LocalMorseRecord: Equatable {
    public let id: UUID
    public let text: String
    public let morseCode: String
    public let flashSignals: [FlashType]
    
    public init(id: UUID, text: String, morseCode: String, flashSignals: [FlashType]) {
        self.id = id
        self.text = text
        self.morseCode = morseCode
        self.flashSignals = flashSignals
    }
}
