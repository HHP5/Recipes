//
//  SceneDelegate.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        window?.overrideUserInterfaceStyle = .light

        window?.makeKeyAndVisible()
	
        let navBar = UINavigationController(rootViewController: RecipeListViewController(viewModel: RecipeListViewModel()))
        window?.rootViewController = navBar
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}
