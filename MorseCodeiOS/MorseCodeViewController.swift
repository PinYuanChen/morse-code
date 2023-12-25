//
// Created on 2023/12/25.
//

import UIKit
import MorseCode

public final class MorseCodeViewController: UIViewController {
    
    public let convertButton = UIButton()
    public let flashButton = UIButton()
    public var currentInputText = ""
    
    public required init(convertor: MorseCodeConvertorPrototype) {
        self.convertor = convertor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        convertButton.addTarget(self, action: #selector(didTappedConvertButton), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)
    }
    
    private let convertor: MorseCodeConvertorPrototype
    private(set) var currentMorseText = ""
}

// MARK: - Private functions
private extension MorseCodeViewController {
    @objc func didTappedConvertButton(_ sender: UIButton) {
        guard !currentInputText.isEmpty else { return }
        let result = convertor.convertToMorseCode(input: currentInputText)
        currentMorseText = result
    }
    
    @objc func didTappedFlashButton(_ sender: UIButton) {
        guard !currentInputText.isEmpty else { return }
        let _ = convertor.convertToMorseFlashSignals(input: currentMorseText)
    }
}
