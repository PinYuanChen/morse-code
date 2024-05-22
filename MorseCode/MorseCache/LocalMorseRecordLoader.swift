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
    
    public func save(_ records: [MorseRecord], completion: @escaping (SaveResult) -> Void) {
        do {
            try store.deleteCachedRecords()
            cache(records, with: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        do {
            let records = try store.retrieve()
            completion(.success(records?.toModels()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func cache(_ records: [MorseRecord], with completion: @escaping (SaveResult) -> Void) {
        do {
            try store.insert(records.toLocal())
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
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
