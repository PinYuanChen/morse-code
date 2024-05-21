//
//  MorseCacheTestHelpers.swift
//  MorseCodeTests
//
//  Created by Champion Chen on 2024/5/21.
//

import Foundation
import MorseCode

func uniqueRecords() -> (records: [MorseRecord], localRecords: [LocalMorseRecord]) {
    let records = [uniqueRecord(), uniqueRecord()]
    let localRecords = records.map {
        LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode)
    }
    
    return (records, localRecords)
}

func uniqueRecord() -> MorseRecord {
    return .init(id: UUID(), text: "any", morseCode: "any")
}


func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
