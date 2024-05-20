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
    typealias RetrievalCompletion = (Error?) -> Void
    
    func deleteCachedRecords(completion: @escaping DeletionCompletion)
    func insert(_ records: [LocalMorseRecord], completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
