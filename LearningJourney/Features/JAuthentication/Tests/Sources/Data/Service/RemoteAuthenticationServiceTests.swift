import XCTest

import CoreNetworking

@testable import JAuthentication

final class RemoteAuthenticationServiceTests: XCTestCase {
    
    // MARK: - Properties
    private let apiSpy = ApiSpy()
    private lazy var sut = RemoteAuthenticationService(apiFactory:  { _ in self.apiSpy })
    
    // MARK: - Unit tests
    
    func test_signInWithApple_itShouldCallApi() {
        // Given
        let expectation = XCTestExpectation()
        
        // When
        sut.signInWithApple(using: .fixture()) { _ in
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(apiSpy.makeCallCount, 1)
        let mirror = Mirror(reflecting: sut)
        guard let currentRequest = mirror.children.first(where: { $0.label == "currentRequest"})?.value as? ApiProtocol
        else {
            XCTFail("Service is not caching the request!")
            return
        }
        XCTAssertEqual(String(describing: currentRequest), String(describing: apiSpy))
    }
    
}

final class ApiSpy: ApiProtocol {
    
    private(set) var makeCallCount = 0
    func make(completion: @escaping Completion) -> ApiProtocol? {
        makeCallCount += 1
        completion(.success(.init()))
        return self
    }
    
    init(endpoint: ApiEndpoint = DummyEndpoint.dummy) {}
}

enum DummyEndpoint: ApiEndpoint {
    var path: String { "" }
    
    case dummy
}
