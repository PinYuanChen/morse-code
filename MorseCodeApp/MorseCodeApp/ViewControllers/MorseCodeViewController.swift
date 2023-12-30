//
// Created on 2023/12/25.
//

import UIKit
import SnapKit
import Combine
import MorseCode

public final class MorseCodeViewController: UIViewController {
    
    // MARK: Public properties
    public let convertButton = CustomButton()
    public let flashButton = CustomButton()
    public var currentInputText = ""
    
    // MARK: Life cycle
    public required init(convertor: MorseCodeConvertorPrototype, flashManager: FlashManagerPrototype) {
        self.convertor = convertor
        self.flashManager = flashManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: Private properties
    private let convertor: MorseCodeConvertorPrototype
    private var flashManager: FlashManagerPrototype
    private let titleLabel = UILabel()
    private let baseView = UIView()
    private let inputBaseView = UIView()
    private let inputTextField = CustomTextField()
    private let morseBaseView = UIView()
    private let morseTextField = UITextField()
    @Published private var isValidInput = false
    private let generator = UIImpactFeedbackGenerator(style: .heavy)
    private var anyCancellables = [AnyCancellable]()
}

// MARK: - Setup UI
private extension MorseCodeViewController {
    func setupUI() {
        view.backgroundColor = .bg04121F
        setupTitleLabel()
        setupBaseView()
        setupInputBaseView()
        setupInputTextField()
        setupMorseBaseView()
        setupMorseTextField()
        setupConvertButton()
        setupFlashButton()
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Morse Code Flashlight"
        titleLabel.textColor = .txt5BC5A5
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupBaseView() {
        baseView.backgroundColor = .bg25333F
        baseView.layer.cornerRadius = 10
        baseView.layer.masksToBounds = true
        
        view.addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalTo(240)
        }
    }
    
    func setupInputBaseView() {
        inputBaseView.backgroundColor = .bg1B262F
        inputBaseView.layer.cornerRadius = 10
        inputBaseView.layer.masksToBounds = true
        
        baseView.addSubview(inputBaseView)
        inputBaseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
    }
    
    func setupInputTextField() {
        inputTextField.textColor = .white
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Input your message here.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        inputTextField.backgroundColor = .clear
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.delegate = self
        inputBaseView.addSubview(inputTextField)
        
        inputTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupMorseBaseView() {
        morseBaseView.backgroundColor = .bg1B262F
        morseBaseView.layer.cornerRadius = 10
        morseBaseView.layer.masksToBounds = true
        
        baseView.addSubview(morseBaseView)
        morseBaseView.snp.makeConstraints {
            $0.top.equalTo(inputBaseView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(inputBaseView)
        }
    }
    
    func setupMorseTextField() {
        morseTextField.textColor = .txt5BC5A5
        morseTextField.backgroundColor = .clear
        morseTextField.attributedPlaceholder = NSAttributedString(
            string: "Morse code output",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.txt5BC5A5]
        )
        morseTextField.isUserInteractionEnabled = false
        morseBaseView.addSubview(morseTextField)
        
        morseTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupConvertButton() {
        convertButton.setImage(.init(systemName: "chevron.down"), for: .normal)
        convertButton.imageView?.tintColor = .white
        convertButton.backgroundColor = .bg5BC5A5
        convertButton.layer.cornerRadius = 20
        convertButton.layer.masksToBounds = true
        convertButton.isEnabled = false
        
        baseView.addSubview(convertButton)
        convertButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalTo(inputBaseView.snp.bottom).offset(-5)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupFlashButton() {
        flashButton.setTitle("Play", for: .normal)
        flashButton.backgroundColor = .bg5BC5A5
        flashButton.layer.cornerRadius = 15
        flashButton.layer.masksToBounds = true
        flashButton.isEnabled = false
        
        baseView.addSubview(flashButton)
        flashButton.snp.makeConstraints {
            $0.leading.size.equalTo(morseBaseView)
            $0.bottom.equalToSuperview().offset(-17)
        }
    }
}

// MARK: - Bind
private extension MorseCodeViewController {
    func bind() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        $isValidInput
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: convertButton)
            .store(in: &anyCancellables)
        
        flashManager.didFinishPlaying = {
            self.flashButton.setTitle("Play", for: .normal)
        }
        
        convertButton.addTarget(self, action: #selector(didTappedConvertButton), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)
    }
}

// MARK: - Private functions
private extension MorseCodeViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didTappedConvertButton(_ sender: UIButton) {
        guard !currentInputText.isEmpty else { return }
        
        generator.impactOccurred()
        let result = convertor.convertToMorseCode(input: currentInputText)
        morseTextField.text = result
        flashButton.isEnabled = true
    }
    
    @objc func didTappedFlashButton(_ sender: UIButton) {
        guard let morseText = morseTextField.text,
              !morseText.isEmpty else {
            return
        }
    
        generator.impactOccurred()
        if flashManager.getCurrentStatus() == .stop {
            let signals = convertor.convertToMorseFlashSignals(input: morseText)
            flashManager.startPlaySignals(signals: signals)
            flashButton.setTitle("Stop", for: .normal)
        } else {
            flashManager.stopPlayingSignals()
            flashButton.setTitle("Play", for: .normal)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        isValidInput = textField.hasText
        currentInputText = textField.text ?? ""
        generator.impactOccurred()
    }
}

// MARK: - UITextFieldDelegate
extension MorseCodeViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let regex = "[A-Za-z0-9 .,?!-/@()]*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}
