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
        
        let convertor = MorseCodeConvertor()
        let flashManager = FlashManager()
        let morseCodeViewController = MorseCodeViewController(presenter: MorseCodePresenter(convertor: convertor, flashManager: flashManager), convertor: convertor, flashManager: flashManager)
        window.rootViewController = morseCodeViewController
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}

