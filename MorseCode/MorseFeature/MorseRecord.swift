//
//  MorseRecordItem.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/16.
//

import Foundation

public struct MorseRecord {
    public let id: UUID
    public let text: String
    public let morseCode: String
    public let flashSignals: [FlashType]
}
