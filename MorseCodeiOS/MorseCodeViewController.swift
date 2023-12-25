//
// Created on 2023/12/25.
//

import UIKit
import MorseCode

public class MorseCodeViewController: UIViewController {
    
    public required init(convertor: MorseCodeConvertorPrototype) {
        self.convertor = convertor
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let convertor: MorseCodeConvertorPrototype
}
