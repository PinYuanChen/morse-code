//
//  MorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public protocol MorseRecordStore {
    func deleteCachedRecords() throws
    func insert(_ records: [LocalMorseRecord]) throws
    func retrieve() throws -> [LocalMorseRecord]?
}
