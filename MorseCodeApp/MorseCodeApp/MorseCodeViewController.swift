//
// Created on 2023/12/25.
//

import UIKit
import SnapKit
import MorseCode

public final class MorseCodeViewController: UIViewController {
    
    // MARK: Public properties
    public let convertButton = UIButton()
    public let flashButton = UIButton()
    public var currentInputText = ""
    
    // MARK: Life cycle
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
    }
    
    // MARK: Private properties
    private let convertor: MorseCodeConvertorPrototype
    private(set) var currentMorseText = ""
    private let titleLabel = UILabel()
    private let baseView = UIView()
    private let inputBaseView = UIView()
    private let inputTextField = CustomTextField()
    private let morseBaseView = UIView()
    private let morseTextField = UITextField()
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
        setupFlashButton()
        setupConvertButton()
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
            $0.height.equalTo(200)
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
        inputBaseView.addSubview(inputTextField)
        
        inputTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
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
}

class CustomTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = .bg275452
            }
        }
    }
}
