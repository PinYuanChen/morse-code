//
//  MorseRecordItem.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/16.
//

import Foundation

public struct MorseRecord: Equatable {
    public let id: UUID
    public let text: String
    public let morseCode: String
    public let flashSignals: [FlashType]
    
    public init(id: UUID, text: String, morseCode: String, flashSignals: [FlashType]) {
        self.id = id
        self.text = text
        self.morseCode = morseCode
        self.flashSignals = flashSignals
    }
}
