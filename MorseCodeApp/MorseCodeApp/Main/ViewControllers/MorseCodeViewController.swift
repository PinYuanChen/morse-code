//
// Created on 2023/12/25.
//

import UIKit
import SnapKit
import MorseCode

public final class MorseCodeViewController: UIViewController {
    
    // MARK: Life cycle
    public required init(presenter: MorseCodePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Private properties
    private var presenter: MorseCodePresenter
    private let convertButton = CustomButton()
    private let flashButton = CustomButton()
    private let titleLabel = UILabel()
    private let inputBaseView = UIView()
    private let inputTextField = CustomTextField()
    private let morseBaseView = UIView()
    private let morseTextField = UITextField()
    private let generator = UIImpactFeedbackGenerator(style: .heavy)
}

// MARK: - Presenter Delegate
extension MorseCodeViewController: MorseCodePresenterDelegate {
    public func showError(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: MorseCodePresenter.alertConfirmTitle, style: .cancel)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: false)
    }
    
    public func updateFlashButton(imageName: String) {
        flashButton.setBackgroundImage(.init(systemName: imageName), for: .normal)
    }
}

// MARK: - Setup UI
private extension MorseCodeViewController {
    func setupUI() {
        view.backgroundColor = .bg04121F
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        setupTitleLabel()
        setupInputBaseView()
        setupInputTextField()
        setupConvertButton()
        setupMorseBaseView()
        setupMorseTextField()
        setupFlashButton()
    }
    
    func setupTitleLabel() {
        titleLabel.text = MorseCodePresenter.title
        titleLabel.textColor = .txt5BC5A5
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupInputBaseView() {
        inputBaseView.backgroundColor = .bg1B262F
        inputBaseView.layer.cornerRadius = 10
        inputBaseView.layer.masksToBounds = true
        
        view.addSubview(inputBaseView)
        inputBaseView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalTo(110)
        }
    }
    
    func setupInputTextField() {
        inputTextField.textColor = .white
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: MorseCodePresenter.inputTextPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        inputTextField.backgroundColor = .clear
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        inputBaseView.addSubview(inputTextField)
        
        inputTextField.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupConvertButton() {
        convertButton.setTitle(MorseCodePresenter.convertButtonTitle, for: .normal)
        convertButton.backgroundColor = .bg5BC5A5
        convertButton.layer.cornerRadius = 15
        convertButton.layer.masksToBounds = true
        convertButton.isEnabled = false
        
        convertButton.addTarget(self, action: #selector(didTappedConvertButton), for: .touchUpInside)
        
        inputBaseView.addSubview(convertButton)
        convertButton.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(10)
            $0.leading.centerX.equalTo(inputTextField)
        }
    }
    
    func setupMorseBaseView() {
        morseBaseView.backgroundColor = .bg1B262F
        morseBaseView.layer.cornerRadius = 10
        morseBaseView.layer.masksToBounds = true
        
        view.addSubview(morseBaseView)
        morseBaseView.snp.makeConstraints {
            $0.top.equalTo(inputBaseView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(inputBaseView)
        }
    }
    
    func setupMorseTextField() {
        morseTextField.textColor = .txt5BC5A5
        morseTextField.backgroundColor = .clear
        morseTextField.attributedPlaceholder = NSAttributedString(
            string: MorseCodePresenter.morseCodePlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.txt5BC5A5]
        )
        morseTextField.isUserInteractionEnabled = false
        morseBaseView.addSubview(morseTextField)
        
        morseTextField.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupFlashButton() {
        flashButton.setBackgroundImage(.init(systemName: "flashlight.on.circle.fill"), for: .normal)
        flashButton.tintColor = .white.withAlphaComponent(0.6)
        flashButton.layer.cornerRadius = 20
        flashButton.layer.masksToBounds = true
        flashButton.isEnabled = false
        
        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)
        
        morseBaseView.addSubview(flashButton)
        flashButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - Private functions
private extension MorseCodeViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didTappedConvertButton(_ sender: UIButton) {
        generator.impactOccurred()
        let result = presenter.convertToMorseCode(text: inputTextField.text ?? "")
        displayMorseCode(code: result)
    }
    
    @objc func didTappedFlashButton(_ sender: UIButton) {
        guard let morseText = morseTextField.text,
              !morseText.isEmpty else {
            return
        }
    
        generator.impactOccurred()
        presenter.playOrPauseFlashSignals(text: morseText)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        convertButton.isEnabled = textField.hasText
        generator.impactOccurred()
    }
    
    func displayMorseCode(code: String) {
        morseTextField.text = code
        flashButton.isEnabled = true
        
        guard let inputText = inputTextField.text else {
            return
        }
        
        Task.init {
            try? await
            presenter.saveToLocalStore(newRecord: .init(id: UUID(), text: inputText, morseCode: code))
        }
    }
}

// MARK: - UITextFieldDelegate
extension MorseCodeViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return presenter.validateInput(string: string, currentText: textField.text as? NSString, range: range)
    }
}
