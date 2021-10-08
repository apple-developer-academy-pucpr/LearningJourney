import XCTest
import CoreNetworking
@testable import JLibrary


final class LibraryRepositoryTests: XCTestCase {
    // MARK: - Properties

    private var libraryRemoteServiceStub = LibraryRemoteServiceStub()
    private var libraryParsingStub = LibraryParsingStub()
    private lazy var sut = LibraryRepository(remoteService: libraryRemoteServiceStub, parser: libraryParsingStub)

    // MARK: - Unit tests

    func test_fetchStrands_whenNotAllowed_itShouldCompleteWithUnauthorizedError() {
        // Given

        let stubError: ApiError = .notAllowed
        libraryRemoteServiceStub.resultToUse = .failure(stubError)
        let expectedError: LibraryRepositoryError = .unauthorized
        var actualError: Error?

        // When

        sut.fetchStrands { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(expectedError.localizedDescription, actualError?.localizedDescription)
    }

    func test_fetchStrands_itShouldHandleLearningStrandsErrors() {
        // Given

        let expectedError: ApiError = .unknown
        let wrappedError: LibraryRepositoryError = .api(expectedError)
        libraryRemoteServiceStub.resultToUse = .failure(expectedError)
        var actualError: Error?

        // When

        sut.fetchStrands { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(wrappedError.localizedDescription, actualError?.localizedDescription)
    }

    func test_fetchStrands_itShouldHandleParsingErrors() {
        // Given

        let expectedError: LibraryRepositoryError = .parsing(.invalidData(DummyError.dummy))
        libraryParsingStub.errorToUse = .invalidData(expectedError)
        libraryRemoteServiceStub.resultToUse = .success(.init())
        var actualError: Error?

        // When

        sut.fetchStrands { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(expectedError.localizedDescription,
                       actualError?.localizedDescription)
    }

    func test_fetchStrands_itShouldParsePayload() {
        // Given

        libraryRemoteServiceStub.resultToUse = .success(.init())
        libraryParsingStub.successToUse = [LearningStrand]()
        var actualResult: [LearningStrand]?

        // When

        sut.fetchStrands { result in
            actualResult = try? result.get()
        }

        // Then

        XCTAssertNotNil(actualResult)
    }

    func test_fetchObjectives_itShouldCallCompletion() {
        // Given

        let completionExpectation = expectation(description: "Completion should be called")

        // When

        sut.fetchObjectives(using: .fixture()) { _ in
            completionExpectation.fulfill()
        }

        // Then

        waitForExpectations(timeout: 1, handler: nil)
    }
}

// MARK: - Testing doubles

final class LibraryRemoteServiceStub: LibraryRemoteServiceProtocol {
    var resultToUse: Result<Data, ApiError> = .failure(.unknown)
    func learningStrands(completion: @escaping Completion) {
        completion(resultToUse)
    }

    
    func learningObjectives(using strandId: Int, completion: @escaping Completion) {
        completion(resultToUse)
    }



    func updateObjective(using objective: LibraryEndpoint.UpdateObjectiveModel, completion: @escaping Completion) {
        completion(resultToUse)
    }
}

final class LibraryParsingSpy: LibraryParsing {
    private(set) var parseDataCallCount = 0
    func parse<T>(_ data: Data) -> Result<T, ParsingError> where T : Decodable {
        parseDataCallCount += 1
        return .failure(.invalidData(LibraryRepositoryError.unknown))
    }
}

final class LibraryParsingStub: LibraryParsing {
    var successToUse: Any?
    var errorToUse: ParsingError = .invalidData(LibraryRepositoryError.unknown)
    func parse<T>(_ data: Data) -> Result<T, ParsingError> {
        if let success = successToUse, let typeSafe = success as? T {
            return .success(typeSafe)
        }

        return .failure(errorToUse)
  }
}

enum DummyError: Error {
    case dummy
}
