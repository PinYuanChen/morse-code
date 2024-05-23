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
    
    public func save(_ records: [MorseRecord]) async throws {
        do {
            try await store.deleteCachedRecords()
            try await cache(records)
        } catch {
            throw error
        }
    }
    
    public func load() async throws -> [MorseRecord]? {
        do {
            let records = try await store.retrieve()
            return records?.toModels()
        } catch {
            throw error
        }
    }
    
    private func cache(_ records: [MorseRecord]) async throws {
        return try await store.insert(records.toLocal())
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
