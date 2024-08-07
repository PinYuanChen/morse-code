//
// Created on 2023/12/27.
//

import UIKit

public class CustomTextField: UITextField {

    public override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = .bg275452
            }
        }
    }
}
