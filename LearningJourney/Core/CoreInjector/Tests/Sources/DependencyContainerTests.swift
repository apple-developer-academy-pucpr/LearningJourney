import XCTest

@testable import CoreInjector

final class DependencyContainerTests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = DefaultDependencyContainer()
    
    // MARK: - Unit tests
    
    func test_register_itShouldRegisterInDependencyFactory() {
        // Given / When
        sut.register(factory: { DummyDependency() }, for: DummyDependency.self)
        
        // Then
        guard let factories: [NSString : DependencyFactory]? = sutProperty(labeled: "dependencyFactories"),
              let factory = factories?.first
        else {
            XCTFail("Sut has no property dependencyFactories!")
            return
        }
        XCTAssertEqual(factory.key, "DummyDependency")
    }
    
    // MARK: - Helpers
    
    private func sutProperty<T>(labeled label: String) -> T? {
        let mirror = Mirror(reflecting: sut)
        let child = mirror
            .children
            .first(where: { $0.label == label })
        
        return child?.value as? T
    }
}
