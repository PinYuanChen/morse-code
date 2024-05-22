//
//  MorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public protocol MorseRecordStore {
    typealias DeletionResult = Result<Void, Error>
    typealias InsertionResult = Result<Void, Error>
    typealias RetrievalResult = Result<[LocalMorseRecord]?, Error>
    
    func deleteCachedRecords() throws
    func insert(_ records: [LocalMorseRecord]) throws
    func retrieve() throws -> [LocalMorseRecord]?
}
