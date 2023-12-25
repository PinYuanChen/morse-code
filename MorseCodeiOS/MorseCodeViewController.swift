//
// Created on 2023/12/25.
//

import UIKit
import MorseCode

public final class MorseCodeViewController: UIViewController {
    
    public required init(convertor: MorseCodeConvertorPrototype) {
        self.convertor = convertor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let convertor: MorseCodeConvertorPrototype
}
