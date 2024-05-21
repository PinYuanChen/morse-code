//
//  LocalMorseRecord.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/20.
//

import Foundation

public struct LocalMorseRecord: Equatable {
    public let id: UUID
    public let text: String
    public let morseCode: String
    
    public init(id: UUID, text: String, morseCode: String) {
        self.id = id
        self.text = text
        self.morseCode = morseCode
    }
}
