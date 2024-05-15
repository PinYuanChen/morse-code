//
// Created on 2023/12/27.
//

import UIKit

public class CustomButton: UIButton {
    public override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
