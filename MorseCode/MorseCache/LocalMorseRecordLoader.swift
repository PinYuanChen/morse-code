//
//  LocalMorseRecordLoader.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public final class LocalMorseRecordLoader {
    
    public typealias SaveResult = Result<Void, Error>
    public typealias LoadResult = Result<[LocalMorseRecord]?, Error>
    
    public init(store: MorseRecordStore) {
        self.store = store
    }
    
    public func save(_ records: [MorseRecord], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedRecords { [weak self] deletionResult in
            guard let self = self else { return }
            
            switch deletionResult {
            case .success:
                self.cache(records, with: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve(completion: completion)
    }
    
    private func cache(_ records: [MorseRecord], with completion: @escaping (SaveResult) -> Void) {
        store.insert(records.toLocal()) { [weak self] insertionResult in
            guard self != nil else { return }
            completion(insertionResult)
        }
    }
    
    private let store: MorseRecordStore
}

private extension Array where Element == MorseRecord {
    func toLocal() -> [LocalMorseRecord] {
        return map { .init(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals) }
    }
}
