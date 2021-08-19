import SwiftUI
import CoreInjector
import CoreNetworking
import CoreAdapters

public struct AuthenticationFeature: Feature {
    
    // MARK: - Dependencies
    
    @Dependency var apiFactory: ApiFactoryProtocol
    @Dependency var notificationCenter: NotificationCenterProtocol
    
    private let scenesFactory: AuthenticationSceneFactoryProtocol
    
    // MARK: - Initialization
    
    public init() {
        
        let factory = AuthenticationSceneFactory(
            loginAssembler: LoginAssembler()
        )
        self.init(scenesFactory: factory)
    }
    
    init(scenesFactory: AuthenticationSceneFactoryProtocol) {
        self.scenesFactory = scenesFactory
    }
    
    // MARK: - Feature resolving
    
    public func build(using route: Route?) -> AnyView {
        if let route = route as? LoginRoute {
            return scenesFactory.loginScene(self, for: route)
        }
        
        preconditionFailure("Unhandled route \(String(describing: route)) sent for feature \(self)")
    }
}
