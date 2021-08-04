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
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenResponseHasErrors_itShouldFail_withRequestFailed() {
        
        // Given
        let expectedError = DummyError.dummy
        let expectation = XCTestExpectation()
        let sut = buildSut()
        urlSessionFake.errorToUse = expectedError

        // When
        
        sut.make { result in
            // Then
            guard case let .failure(error) = result,
                  case let .requestFailed(requestError) = error
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(requestError.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenResponseIsNil_itShouldFail_withNonHTTPResponse() {
        
        // Given
        let expectedError = ApiError.nonHTTPResponse
        let expectation = XCTestExpectation()
        let sut = buildSut()
        urlSessionFake.responseToUse = nil

        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenDataIsNiw_itShouldFail_withNoData() {
        
        // Given
        let expectedError = ApiError.noData
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture()
        urlSessionFake.dataToUse = nil
        
        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenStatusCodeIsLessThen300AnGreaterThen200_itShouldFail_withUnhandledStatusCode() {
        
        // Given
        let statusCodeStub = 20
        let expectedError = ApiError.unhandledtatusCode(statusCodeStub)
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture(statusCode: statusCodeStub)
        urlSessionFake.dataToUse = .init()
        
        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenCodeIsValid_itShouldSuccess_withData() {
        
        // Given
        let expectedData = Data(repeating: 2, count: 10)
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture()
        urlSessionFake.dataToUse = expectedData
        
        // When
        sut.make { result in
            // Then
            guard case let .success(actualData) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(actualData, expectedData)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenStatusCodeIs401_itShouldFail_withnotAllowed() {
        
        // Given
        let statusCodeStub = 401
        let expectedError = ApiError.notAllowed
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture(statusCode: statusCodeStub)
        urlSessionFake.dataToUse = .init()
        
        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenStatusCodeIsLessThen500AndGreaterThen400_itShouldFail_withClientError() {
        
        // Given
        let statusCodeStub = 444
        let expectedError = ApiError.clientError(statusCodeStub)
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture(statusCode: statusCodeStub)
        urlSessionFake.dataToUse = .init()
        
        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenStatusCodeIsLessThen600AndGreaterThen500_itShouldFail_withExternalError() {
        
        // Given
        let statusCodeStub = 555
        let expectedError = ApiError.externalError(statusCodeStub)
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture(statusCode: statusCodeStub)
        urlSessionFake.dataToUse = .init()
        
        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_make_whenStatusCodeIsNotHandled_itShouldFail_withUnkownError() {
        
        // Given
        let statusCodeStub = 777
        let expectedError = ApiError.unknown
        let expectation = XCTestExpectation()
        let sut = buildSut()
        
        urlSessionFake.responseToUse = HTTPURLResponse.fixture(statusCode: statusCodeStub)
        urlSessionFake.dataToUse = .init()
        
        // When
        sut.make { result in
            // Then
            guard case let .failure(error) = result
            else {
                XCTFail("Expected test to return an error")
                return
            }
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
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

enum DummyError: Error {
    case dummy
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

extension HTTPURLResponse {
    static func fixture(
        statusCode: Int = 200
    ) -> HTTPURLResponse? {
        .init(
            url: .init(string: "http://validurl.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)
    }
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
