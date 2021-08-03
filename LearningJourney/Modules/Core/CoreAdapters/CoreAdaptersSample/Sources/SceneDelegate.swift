import UIKit
import SwiftUI
import CoreAdapters

final class SceneDelegate: UIResponder, UISceneDelegate {
    
    // MARK: - Properties
    
    private var window: UIWindow?
    
    // MARK: - SceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let contentView = Text("salve")
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        window.makeKeyAndVisible()
    
        self.window = window
    }
}
