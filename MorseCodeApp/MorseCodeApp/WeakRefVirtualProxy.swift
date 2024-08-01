//
//  WeakRefVirtualProxy.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/8/1.
//

import UIKit
import MorseCode

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: MorseCodePresenterDelegate where T: MorseCodePresenterDelegate {
    func showError(title: String?, message: String) {
        object?.showError(title: title, message: message)
    }
    
    func updateFlashButton(status: MorseCode.FlashStatusType, enable: Bool) {
        object?.updateFlashButton(status: status, enable: enable)
    }
}

extension WeakRefVirtualProxy: RecordsPresenterDelegate where T: RecordsPresenterDelegate {
    func reloadData() {
        object?.reloadData()
    }
    
    func showError(title: String?, message: String) {
        object?.showError(title: title, message: message)
    }
}
