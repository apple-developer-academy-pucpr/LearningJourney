import SwiftUI

public protocol Feature {
    func build(using route: Route?) -> AnyView
    func resolve(using container: DependencyContainer)
    init()
}

extension Feature {
    static func initialize(using container: DependencyContainer) -> Feature {
        let feature = Self.init()
        feature.resolve(using: container)
        return feature
    }
}

public extension Feature {
    func resolve(using container: DependencyContainer) {
        let mirror = Mirror(reflecting: self)
        mirror.children
            .compactMap { $0.value as? Resolvable }
            .forEach { $0.resolve(using: container) }
    }
}

