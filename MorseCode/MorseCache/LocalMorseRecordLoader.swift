//
//  LocalMorseRecordLoader.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/17.
//

import Foundation

public final class LocalMorseRecordLoader {
    
    public typealias SaveResult = Error?
    
    public init(store: MorseRecordStore) {
        self.store = store
    }
    
    public func save(_ records: [MorseRecord], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedRecords { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(records, with: completion)
            }
        }
    }
    
    private func cache(_ records: [MorseRecord], with completion: @escaping (Error?) -> Void) {
        store.insert(records) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    private let store: MorseRecordStore
}
