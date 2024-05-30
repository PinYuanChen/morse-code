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
        let morseCodeViewController = MorseUIComposer.composeMorseCode(with: localLoader)
        let recordsViewController = MorseUIComposer.composeRecords(loader: localLoader)
        
        let mainTabBarController = MainTabBarController(viewControllers: [morseCodeViewController, recordsViewController])
        
        window.rootViewController = mainTabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    private var localLoader: LocalMorseRecordLoader {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
        let codableStore = CodableMorseRecordStore(storeURL: storeURL)
        return .init(store: codableStore)
    }
}

