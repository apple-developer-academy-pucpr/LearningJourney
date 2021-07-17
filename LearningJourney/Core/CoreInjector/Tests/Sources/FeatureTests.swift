import XCTest
import SwiftUI

@testable import CoreInjector

final class FeatureTests: XCTestCase {
    
    // MARK: - Unit tests
    
    func test_resolve_itShouldResolveAllDependencies() {
        // Given
        let spy = ResolvableSpy()
        let container = DefaultDependencyContainer()
        let sut = DummyFeature()
        
        container.register(factory: { spy }, for: ResolvableSpy.self )
        
        // When
        sut.resolve(using: container)
        
        // Then
        XCTAssertEqual(spy.resolveCallCount, 1)
    }
}

final class ResolvableSpy: Resolvable {
    
    private(set) var resolveCallCount = 0
    
    func resolve(using container: DependencyContainer) {
        resolveCallCount += 1
    }
}

final class DummyFeature: Feature {
    
    @Dependency var spy: ResolvableSpy
    
    func build(using route: Route?) -> AnyView {
        AnyView(Text("Dummy"))
    }
}

final class DummyContainer: DependencyContainer {
    func make<T>(_ type: T.Type) -> T? { nil }
    
    func register<T>(factory: @escaping DependencyFactory, for type: T.Type) {}
}
