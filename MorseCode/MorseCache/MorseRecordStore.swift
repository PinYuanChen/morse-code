//
//  MorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public protocol MorseRecordStore {
    typealias DeletionResult = Result<Void, Error>
        typealias DeletionCompletion = (DeletionResult) -> Void
        
        typealias InsertionResult = Result<Void, Error>
        typealias InsertionCompletion = (InsertionResult) -> Void
        
        typealias RetrievalResult = Result<[LocalMorseRecord]?, Error>
        typealias RetrievalCompletion = (RetrievalResult) -> Void

    func deleteCachedRecords(completion: @escaping DeletionCompletion)
    func insert(_ records: [LocalMorseRecord], completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
