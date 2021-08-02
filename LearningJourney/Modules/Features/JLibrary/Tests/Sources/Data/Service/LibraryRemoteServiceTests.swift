import XCTest
import CoreNetworking

@testable import JLibrary

final class LibraryRemoteServiceTests: XCTestCase {
    
    // MARK: - Properties
    private let apiSpy = ApiSpy()
    private lazy var factory = ApiFactoryMock(api: apiSpy)
    private lazy var sut = LibraryRemoteService(apiFactory: factory)
    
    
    // MARK: - Unit tests
    
    func test_learningStrands_itShouldCallApi() {
        // Given
        let expectation = XCTestExpectation()
        
        // When
        sut.learningStrands { _ in
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(factory.endpointPassed?.absoluteStringUrl, LibraryEndpoint.fetchStrand.absoluteStringUrl)
        XCTAssertEqual(apiSpy.makeCallCount, 1)
    }
    
    func test_learningObjectives_itShouldCallApi() {
        // Given
        let expectation = XCTestExpectation()
        let strandIdDummy = 1
        
        // When
        sut.learningObjectives(using: strandIdDummy) { _ in
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(factory.endpointPassed?.absoluteStringUrl, LibraryEndpoint.fetchObjectives(strandIdDummy).absoluteStringUrl)
        XCTAssertEqual(apiSpy.makeCallCount, 1)
    }
    
    func test_updateObjective_itShouldCallApi() {
        // Given
        let expectation = XCTestExpectation()
        let objectiveDummy: LibraryEndpoint.UpdateObjectiveModel = .init(
            id: 1,
            isComplete: true)
        let expectedEndpoint = LibraryEndpoint.updateObjective(objectiveDummy)
        
        // When
        sut.updateObjective(using: objectiveDummy) { _ in
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        let actualEndpoint = factory.endpointPassed
        XCTAssertEqual(actualEndpoint?.absoluteStringUrl, expectedEndpoint.absoluteStringUrl)
        XCTAssertEqual(actualEndpoint?.body, expectedEndpoint.body)
        XCTAssertEqual(apiSpy.makeCallCount, 1)
    }
}

final class ApiSpy: ApiProtocol {
    
    private(set) var makeCallCount = 0
    private(set) var endpointPassed: ApiEndpoint
    
    func make(completion: @escaping Completion) -> ApiProtocol? {
        makeCallCount += 1
        completion(.success(.init()))
        return self
    }
    
    init(endpoint: ApiEndpoint = DummyEndpoint.dummy) {
        self.endpointPassed = endpoint
    }
}

enum DummyEndpoint: ApiEndpoint {
    var path: String { "" }
    
    case dummy
}

final class ApiFactoryMock: ApiFactoryProtocol {
    
    private let apiToUse: ApiProtocol
    private(set) var endpointPassed: ApiEndpoint?
    
    init(api: ApiProtocol) {
        apiToUse = api
    }
    
    func make(_ endpoint: ApiEndpoint) -> ApiProtocol {
        endpointPassed = endpoint
        return apiToUse
    }
}


