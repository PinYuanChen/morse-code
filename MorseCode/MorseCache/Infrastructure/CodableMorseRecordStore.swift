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
    
    private let queue = DispatchQueue(label: "\(CodableMorseRecordStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve() async throws -> [LocalMorseRecord]? {
        let storeURL = self.storeURL
        guard let data = try? Data(contentsOf: storeURL) else {
            return nil
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            queue.async() {
                do {
                    let decoder = JSONDecoder()
                    let records = try decoder.decode([CodableMorseRecord].self, from: data)
                    let localRecords = records.map { LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
                    continuation.resume(returning: localRecords)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func insert(_ records: [LocalMorseRecord]) async throws {
        let storeURL = self.storeURL
        
        try await withCheckedThrowingContinuation { continuation in
            queue.async(flags: .barrier) {
                let encoder = JSONEncoder()
                let codableRecords = records.map { CodableMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
                do {
                    let encoded = try encoder.encode(codableRecords)
                    try encoded.write(to: storeURL)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func deleteCachedRecords() async throws {
        let storeURL = self.storeURL
        
        try await withCheckedThrowingContinuation { continuation in
            queue.async(flags: .barrier) {
                do {
                    if FileManager.default.fileExists(atPath: storeURL.path) {
                        try FileManager.default.removeItem(at: storeURL)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
