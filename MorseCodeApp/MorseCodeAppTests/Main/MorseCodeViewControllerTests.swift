//
// Created on 2023/12/25.
//

import XCTest
import MorseCode
import MorseCodeApp

final class MorseCodeViewControllerTests: XCTestCase { 
    
    func test_morseCodeUI() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "MorseCodeViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "MorseCodeViewController_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "MorseCodeViewController_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> MorseCodeViewController {
        let viewController = MorseCodeViewController(presenter: .init(convertor: MorseCodeConvertor(), flashManager: FlashManager()))
        return viewController
    }
}
