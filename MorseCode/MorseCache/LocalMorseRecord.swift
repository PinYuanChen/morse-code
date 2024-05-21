//
//  LocalMorseRecord.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/20.
//

import Foundation

public struct LocalMorseRecord: Equatable, Codable {
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        morseCode = try values.decode(String.self, forKey: .morseCode)
        flashSignals = try values.decode([FlashType].self, forKey: .flashSignals)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case morseCode
        case flashSignals
    }
}
