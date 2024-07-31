//
//  MorseCodeViewController+TestHelpers.swift
//  MorseCodeAppTests
//
//  Created by Champion Chen on 2024/7/31.
//

import MorseCode
import MorseCodeApp

extension MorseCodeViewController {
    func simulateTypeText(text: String) {
        inputTextField.text = text
        inputTextField.sendActions(for: .editingChanged)
    }
    
    func simulateDeleteAllText() {
        inputTextField.text = ""
        inputTextField.sendActions(for: .editingChanged)
    }
    
    func simulateConvertText(text: String) {
        simulateTypeText(text: text)
        convertButton.sendActions(for: .touchUpInside)
    }
    
    func simulateFlashButton(enable: Bool) {
        updateFlashButton(status: .stop, enable: enable)
    }
}
