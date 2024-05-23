//
// Created on 2023/12/25.
//

import UIKit
import MorseCode

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let mainTabBarController = MainTabBarController(viewControllers: [makeMorseCodeViewController(), makeRecordsViewController()])
        
        window.rootViewController = mainTabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    // MARK: - Main
    private func makeMorseCodeViewController() -> MorseCodeViewController {
        let convertor = MorseCodeConvertor()
        let flashManager = FlashManager()
        
        let morseCodeViewController = MorseCodeViewController(presenter: MorseCodePresenter(convertor: convertor, flashManager: flashManager, localLoader: localLoader))
        morseCodeViewController.tabBarItem = MainTabBarItem(.main)
        return morseCodeViewController
    }

    private var localLoader: LocalMorseRecordLoader {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
        let codableStore = CodableMorseRecordStore(storeURL: storeURL)
        return .init(store: codableStore)
    }
    
    // MARK: - Records
    private func makeRecordsViewController() -> RecordsViewController {
        let recordsViewController = RecordsViewController()
        recordsViewController.tabBarItem = MainTabBarItem(.records)
        return recordsViewController
    }
}

