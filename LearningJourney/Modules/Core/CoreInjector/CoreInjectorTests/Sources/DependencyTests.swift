import XCTest

@testable import CoreInjector

final class DependencyTests: XCTestCase {

    // MARK: - Properties
    
    private let containerStub = ContainerStub()
    private var errorsUsed: [DependencyInjectionError<DummyDependency>] = []

    // MARK: - Unit tests
    
    func test_resolve_whenContainerHasNoValue_itShouldHandleError_withNotRegistered() {
        // Given
        let sut = buildSut()
        containerStub.dummyToUse = nil
        
        // When
        sut.resolve(using: containerStub)
        
        // Then
        guard let error = errorsUsed.first,
              case .notRegistered = error
        else {
            XCTFail("Expected error to be handled!")
            return
        }
        XCTAssertEqual(errorsUsed.count, 1)
    }
    
    func test_resolve_whenResolvedValueIsNotNil_itShouldHandleError_withResolvedTwice() {
        // Given
        let sut = buildSut()
        containerStub.dummyToUse = .init()
        sut.resolve(using: containerStub)
        
        // When
        sut.resolve(using: containerStub)
        
        // Then
        guard let error = errorsUsed.first,
              case .resolvedTwice = error
        else {
            XCTFail("Expected error to be handled!")
            return
        }
        XCTAssertEqual(errorsUsed.count, 1)
    }
    
    // MARK: - Helpers
    
    private func buildSut(
        resolvedValue: DummyDependency? = nil
    ) -> Dependency<DummyDependency> {
        .init(resolvedValue: resolvedValue) { self.errorsUsed.append($0) }
    }
}

final class DummyDependency {}

final class ContainerStub: DependencyContainer {
    
    var dummyToUse: DummyDependency?
    
    func make<T>(_ type: T.Type) -> T? {
        dummyToUse as? T
    }
    
    func register<T>(factory: @escaping DependencyFactory, for type: T.Type) {}
}
