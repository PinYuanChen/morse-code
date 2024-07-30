//
//  MorseRecordLoaderPrototype.swift
//  MorseCode
//
//  Created by Champion Chen on 2024/5/20.
//

import Foundation

public protocol MorseRecordLoaderPrototype {
    typealias SaveResult = Result<Void, Error>
    typealias SaveCompletion = (SaveResult) -> Void
    
    
    typealias LoadResult = Result<[MorseRecord]?, Error>
    typealias LoadCompletion = (LoadResult) -> Void
    
    func save(_ records: [MorseRecord], completion: @escaping SaveCompletion)
    func load(completion: @escaping LoadCompletion)
}
