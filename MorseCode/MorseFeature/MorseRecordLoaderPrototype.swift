//
//  MorseRecordLoaderPrototype.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/20.
//

import Foundation

public protocol MorseRecordLoaderPrototype {
    typealias SaveResult = Result<Void, Error>
    typealias LoadResult = Result<[MorseRecord]?, Error>
    
    func save(_ records: [MorseRecord], completion: @escaping (SaveResult) -> Void)
    func load(completion: @escaping (LoadResult) -> Void)
}
