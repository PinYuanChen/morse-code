//
// Created on 2023/12/25.
//

import XCTest
import MorseCode
import MorseCodeApp

final class MorseCodeViewControllerSnapshotTests: XCTestCase { 
    
    func test_morseCodeUI() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "MorseCodeViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "MorseCodeViewController_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> MorseCodeViewController {
        let viewController = MorseUIComposer.composeMorseCode(convertor: MorseConvertor(), loader: LoaderSpy(), flashManager: FlashManager())
        return viewController
    }
}
