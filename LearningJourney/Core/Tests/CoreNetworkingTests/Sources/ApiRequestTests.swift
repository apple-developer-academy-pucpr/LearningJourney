import XCTest

import CoreAdapters

@testable import CoreNetworking

final class ApiRequstTests: XCTestCase {

    // MARK: - Properties
   
    private let dispatchFake = DispatchSpy()
    private let urlSessionFake = URLSessionStub()
    
    // MARK: - Unit tests
    
    func test_make_whenEndpointHasInvalidUrl_itShouldComplete_withInvalidUrl() {
        // Given
        let expectation = XCTestExpectation()
        let sut = buildSut(using: .invalidUrl)
        
        // When
        sut.make { result in
            guard case let .failure(error) = result else {
                XCTFail("Expected test to return an error")
                return
            }
            XCTAssertEqual(error.localizedDescription, ApiError.invalidUrl.localizedDescription)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func buildSut(
        using endpoint: EndpointStub = .dummy
    ) -> ApiRequest{
        ApiRequest(
            endpoint,
            session: urlSessionFake,
            dispatchQueue: dispatchFake)
    }
}

enum EndpointStub: ApiEndpoint {
    case dummy
    case invalidUrl
    
    
    var absoluteStringUrl: String {
        switch self {
        case .dummy:
            return "http://validurl.com"
        case .invalidUrl:
            return "invalid url"
        }
    }
    
    var path: String { "/" }
}


final class DispatchSpy: Dispatching {
    
    private(set) var asyncCallCount = 0
    
    func async(_ work: @escaping () -> Void) {
        asyncCallCount += 1
        work()
    }
}

final class URLSessionStub: URLSessionProtocol {
    
    var dataToUse: Data?
    var responseToUse: URLResponse?
    var errorToUse: Error?
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol? {
        
        completionHandler(dataToUse, responseToUse, errorToUse)
        return nil
    }
}
