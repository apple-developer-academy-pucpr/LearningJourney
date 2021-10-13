import UIKit
import SwiftUI
import CoreNetworking
import CoreInjector
import CoreAuthentication
import CoreAdapters
import JLibrary

final class SceneDelegate: UIResponder, UISceneDelegate {
    
    // MARK: - Properties
    
    private var window: UIWindow?
    
    private let router = RouterService()
    
    // MARK: - SceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        registerDependencies()
        
        let contentView = router.initialize(
            using: LibraryFeature.self)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        window.makeKeyAndVisible()
    
        self.window = window
    }
    
    private func registerDependencies() {
        router.register({ ApiFactory() }, for: ApiFactoryProtocol.self)
        router.register({ self.router }, for: RoutingService.self)
        router.register({ TokenManagerDummy() }, for: TokenCleaning.self)
        router.register({ NotificationCenter()}, for: NotificationCenterProtocol.self)
        router.register(routeHandler: LibraryRouteHandler())
    }
}

final class ApiFactory: ApiFactoryProtocol {
    func make(_ endpoint: ApiEndpoint) -> ApiProtocol {
        ApiDummy(endpoint: endpoint)
    }
    
    final class ApiDummy: ApiProtocol {
        init(endpoint: ApiEndpoint) {
            print("REQUEST", endpoint)
        }
        
        
        func make(completion: @escaping Completion) -> ApiProtocol? {
            let mockString = "[{\"id\":1,\"name\":\"Professional Skills\",\"goals\":[{\"id\":1,\"name\":\"Personal Growth\",\"progress\":0.25},{\"id\":2,\"name\":\"Communication\",\"progress\":0},{\"id\":3,\"name\":\"Storytelling\",\"progress\":0},{\"id\":4,\"name\":\" Creative Workflow\",\"progress\":0},{\"id\":5,\"name\":\"Presentations\",\"progress\":0},{\"id\":6,\"name\":\"Creative Workflow\",\"progress\":0},{\"id\":7,\"name\":\"Collaboration\",\"progress\":0},{\"id\":8,\"name\":\"Employability\",\"progress\":0}]},{\"id\":2,\"name\":\"Design\",\"goals\":[{\"id\":9,\"name\":\"Game design and art direction\",\"progress\":0.3},{\"id\":10,\"name\":\"Design fundamentals\",\"progress\":0.2857142857142857},{\"id\":11,\"name\":\"Hig Basic\",\"progress\":0},{\"id\":12,\"name\":\"Prototyping\",\"progress\":0.2},{\"id\":13,\"name\":\"Accessibility\",\"progress\":0},{\"id\":14,\"name\":\"Branding\",\"progress\":0},{\"id\":15,\"name\":\"Hig Advanced\",\"progress\":0},{\"id\":16,\"name\":\"User Centered Design\",\"progress\":0}]},{\"id\":3,\"name\":\"Technical\",\"goals\":[{\"id\":17,\"name\":\"Operating Systems\",\"progress\":0.25},{\"id\":18,\"name\":\"Networking and Backend\",\"progress\":0},{\"id\":19,\"name\":\"Media,  Animation and Games\",\"progress\":0},{\"id\":20,\"name\":\"Developer Tools\",\"progress\":0},{\"id\":21,\"name\":\"Supporting Frameworks\",\"progress\":0.014492753623188406},{\"id\":22,\"name\":\"Interfaces Development\",\"progress\":0.02857142857142857},{\"id\":23,\"name\":\"Logic and Programming\",\"progress\":0.5333333333333333},{\"id\":24,\"name\":\"Platform Functionalities\",\"progress\":0}]},{\"id\":4,\"name\":\"App Business and Marketing\",\"goals\":[{\"id\":25,\"name\":\"App Marketing\",\"progress\":0.3333333333333333},{\"id\":26,\"name\":\"Legal Guidelines\",\"progress\":0},{\"id\":27,\"name\":\"Store Presence\",\"progress\":0},{\"id\":28,\"name\":\"Store Guidelines\",\"progress\":0},{\"id\":29,\"name\":\"App Business\",\"progress\":0},{\"id\":30,\"name\":\"User Engagement\",\"progress\":0},{\"id\":31,\"name\":\"Entrepreneurship\",\"progress\":0}]},{\"id\":5,\"name\":\"Process\",\"goals\":[{\"id\":32,\"name\":\"Scrum\",\"progress\":0.2},{\"id\":33,\"name\":\"Ongoing Activities\",\"progress\":0},{\"id\":34,\"name\":\"Investigate \",\"progress\":0},{\"id\":35,\"name\":\"Engage\",\"progress\":0},{\"id\":36,\"name\":\"Act\",\"progress\":0},{\"id\":37,\"name\":\"Project Management\",\"progress\":0}]}]"
            guard let mockData = mockString.data(using: .utf8) else { return self }
            completion(.success(mockData))
            return self
        }
    }
}

final class TokenManagerDummy: TokenCleaning {
    func clear() {
        print("Cleared token!")
    }
}

