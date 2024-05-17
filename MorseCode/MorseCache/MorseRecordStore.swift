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
    func insert(_ records: [MorseRecord], completion: @escaping InsertionCompletion)
}
