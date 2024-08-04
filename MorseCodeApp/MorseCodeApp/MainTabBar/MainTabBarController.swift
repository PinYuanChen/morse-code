//
//  MainTabBarController.swift
//  MorseCodeApp
//
//  Created by Champion Chen on 2024/5/23.
//

import UIKit

class MainTabBarItem: UITabBarItem {
    required init(_ item: TabBarItemType) {
        super.init()
        title = item.title
        image = .init(systemName: item.image)?.withRenderingMode(.alwaysTemplate)
        selectedImage = .init(systemName: item.selectedImage)?.withRenderingMode(.alwaysTemplate)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainTabBarController: UITabBarController {
    required init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        setViewControllers(viewControllers, animated: false)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .bg1B262F
        appearance.stackedLayoutAppearance.selected.iconColor = .txt5BC5A5
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.txt5BC5A5]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
