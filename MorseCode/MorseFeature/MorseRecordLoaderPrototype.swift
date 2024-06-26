//
//  MorseRecordLoaderPrototype.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/20.
//

import Foundation

public protocol MorseRecordLoaderPrototype {
    func save(_ records: [MorseRecord]) async throws
    func load() async throws -> [MorseRecord]?
}
