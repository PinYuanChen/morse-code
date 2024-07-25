//
//  SharedTestHelpers.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/7/25.
//

import Foundation
import MorseCode

func anyRecord() -> MorseRecord {
    .init(id: UUID(), text: "any", morseCode: "... ---")
}
