//
//  LocalMorseRecordLoader.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public final class LocalMorseRecordLoader: MorseRecordLoaderPrototype {
    
    public init(store: MorseRecordStore) {
        self.store = store
    }
    
    public func save(_ records: [MorseRecord]) throws {
        do {
            try store.deleteCachedRecords()
            try cache(records)
        } catch {
            throw error
        }
    }
    
    public func load() throws -> [MorseRecord]? {
        do {
            let records = try store.retrieve()
            return records?.toModels()
        } catch {
            throw error
        }
    }
    
    private func cache(_ records: [MorseRecord]) throws {
        return try store.insert(records.toLocal())
    }
    
    private let store: MorseRecordStore
}

private extension Array where Element == MorseRecord {
    func toLocal() -> [LocalMorseRecord] {
        return map { .init(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
    }
}

private extension Array where Element == LocalMorseRecord {
    func toModels() -> [MorseRecord] {
        return map { .init(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
    }
}
