//
//  CodableMorseRecordStore.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/21.
//

import Foundation

public class CodableMorseRecordStore: MorseRecordStore {
    
    private struct CodableMorseRecord: Codable {
        let id: UUID
        let text: String
        let morseCode: String
        
        var local: LocalMorseRecord {
            .init(id: id, text: text, morseCode: morseCode)
        }
    }
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve() throws -> [LocalMorseRecord]? {
        let storeURL = self.storeURL
        
        guard let data = try? Data(contentsOf: storeURL) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let records = try decoder.decode([CodableMorseRecord].self, from: data)
        
        return records.map { LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
    }
    
    public func insert(_ records: [LocalMorseRecord]) throws {
        let storeURL = self.storeURL
        let encoder = JSONEncoder()
        let codableRecords = records.map { CodableMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
        
        let encoded = try? encoder.encode(codableRecords)
        try encoded?.write(to: storeURL)
    }
    
    public func deleteCachedRecords() throws {
        let storeURL = self.storeURL
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return
        }
        
        return try FileManager.default.removeItem(at: storeURL)
    }
}
