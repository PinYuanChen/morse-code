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
    
    public func retrieve(completion: @escaping RetrievalCompletion)  {
        guard (try? Data(contentsOf: storeURL)) != nil else {
            return  completion(.success(.none))
        }
        
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.success(.none))
            }
            
            do {
                let decoder = JSONDecoder()
                let records = try decoder.decode([CodableMorseRecord].self, from: data)
                completion(.success(records.map { LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode) }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ records: [LocalMorseRecord], completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let codableRecords = records.map { CodableMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode) }
                
                let encoded = try encoder.encode(codableRecords)
                try encoded.write(to: storeURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedRecords(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(.success(()))
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
