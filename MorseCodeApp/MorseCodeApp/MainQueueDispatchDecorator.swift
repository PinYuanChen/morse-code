//
//  MainQueueDispatchDecorator.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/7/30.
//

import Foundation
import MorseCode

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension MainQueueDispatchDecorator: MorseRecordLoaderPrototype where T == MorseRecordLoaderPrototype {
    func save(_ records: [MorseCode.MorseRecord], completion: @escaping SaveCompletion) {
        decoratee.save(records) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
    
    func load(completion: @escaping LoadCompletion) {
        decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
    
}
