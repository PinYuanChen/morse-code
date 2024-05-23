//
//  MorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public protocol MorseRecordStore {
    func deleteCachedRecords() async throws
    func insert(_ records: [LocalMorseRecord]) async throws
    func retrieve() async throws -> [LocalMorseRecord]?
}
