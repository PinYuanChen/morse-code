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
        LocalMorseRecord(id: $0.id, text: $0.text, morseCode: $0.morseCode, flashSignals: $0.flashSignals)
    }
    
    return (records, localRecords)
}

func uniqueRecord() -> MorseRecord {
    return .init(id: UUID(), text: "any", morseCode: "any", flashSignals: [])
}
