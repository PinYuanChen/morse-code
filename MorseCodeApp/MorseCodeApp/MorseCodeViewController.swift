//
// Created on 2023/12/25.
//

import UIKit
import SnapKit
import MorseCode

public final class MorseCodeViewController: UIViewController {
    
    public let convertButton = UIButton()
    public let flashButton = UIButton()
    public let resetButton = UIButton()
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
        setupUI()
        convertButton.addTarget(self, action: #selector(didTappedConvertButton), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didTappedResetButton), for: .touchUpInside)
    }
    
    private let convertor: MorseCodeConvertorPrototype
    private(set) var currentMorseText = ""
}

// MARK: - Setup UI
private extension MorseCodeViewController {
    func setupUI() {
        setupTitleLabel()
        setupBaseView()
        setupInputBaseView()
        setupInputTextField()
        setupResetButton()
        setupMorseBaseView()
        setupMorseTextField()
        setupFlashButton()
        setupConvertButton()
    }
    
    func setupTitleLabel() {
        
    }
    
    func setupBaseView() {
        
    }
    
    func setupInputBaseView() {
        
    }
    
    func setupInputTextField() {
        
    }
    
    func setupResetButton() {
        
    }
    
    func setupMorseBaseView() {
        
    }
    
    func setupMorseTextField() {
        
    }
    
    func setupFlashButton() {
        
    }
    
    func setupConvertButton() {
        
    }
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
    
    @objc func didTappedResetButton(_ sender: UIButton) {
        currentInputText = ""
    }
}