import XCTest
import CoreNetworking
@testable import JLibrary


final class LibraryRepositoryTests: XCTestCase {
    // MARK: - Properties

    private let libraryRemoteServiceStub = LibraryRemoteServiceStub()
    private let libraryParsingStub = LibraryParsingStub()
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

    func test_fetchStrands_whenApiFails_itShouldCompleteWithApiError() {
        // Given

        let dummyError: ApiError = .unknown
        let expectedError: LibraryRepositoryError = .api(dummyError)
        libraryRemoteServiceStub.resultToUse = .failure(dummyError)
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

    func test_fetchStrands_whenParsingFails_itShouldCompleteWithParsingError() {
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

    func test_fetchStrands_whenItSucceeds_itShouldCompleteWithParsedPayload() {
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

    func test_fetchObjectives_whenApiSucceeds_andParsingFails_itShouldCompleteWithParsingError() {
        // Given

        libraryRemoteServiceStub.resultToUse = .success(.init())
        let dummyError: ParsingError = .invalidData(DummyError.dummy)
        let expectedError: LibraryRepositoryError = .parsing(dummyError)
        libraryParsingStub.errorToUse = dummyError
        var actualError: Error?

        // When

        sut.fetchObjectives(using: .fixture()) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(expectedError.localizedDescription,
                       actualError?.localizedDescription)
    }

    func test_fetchObjectives_whenApiFails_itShouldCompleteWithApiError() {
        // Given

        let dummyError: ApiError = .unknown
        libraryRemoteServiceStub.resultToUse = .failure(dummyError)
        let expectedError: LibraryRepositoryError = .api(dummyError)
        var actualError: Error?

        // When

        sut.fetchObjectives(using: .fixture()) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(expectedError.localizedDescription,
                       actualError?.localizedDescription)
    }

    func test_fetchObjectives_whenItSucceeds_itShouldReturnParsedData() {
        // Given

        libraryParsingStub.successToUse = [LearningObjective]()
        libraryRemoteServiceStub.resultToUse = .success(.init())
        var actualResult: [LearningObjective]?

        // When

        sut.fetchObjectives(using: .fixture()) { result in
            actualResult = try? result.get()
        }

        // Then

        XCTAssertNotNil(actualResult)
    }

    func test_updateObjective_whenApiSucceeds_andParsingFails_itShouldCompleteWithParsingError() {
        // Given

        libraryRemoteServiceStub.resultToUse = .success(.init())
        let dummyError: ParsingError = .invalidData(DummyError.dummy)
        let expectedError: LibraryRepositoryError = .parsing(dummyError)
        libraryParsingStub.errorToUse = dummyError
        var actualError: Error?

        // When

        sut.updateObjective(newObjective: .fixture()) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(expectedError.localizedDescription,
                       actualError?.localizedDescription)
    }

    func test_updateObjective_whenApiFails_itShouldCompleteWithApiError() {
        // Given

        let dummyError: ApiError = .unknown
        libraryRemoteServiceStub.resultToUse = .failure(dummyError)
        let expectedError: LibraryRepositoryError = .api(dummyError)
        var actualError: Error?

        // When

        sut.updateObjective(newObjective: .fixture()) { result in
            guard case let .failure(error) = result else {
                return XCTFail("Expected test to fail")
            }
            actualError = error
        }

        // Then

        XCTAssertEqual(expectedError.localizedDescription,
                       actualError?.localizedDescription)
    }

    func test_updateObjective_whenItSucceeds_itShouldReturnParsedData() {
        // Given

        libraryParsingStub.successToUse = LearningObjective.fixture()
        libraryRemoteServiceStub.resultToUse = .success(.init())
        var actualResult: LearningObjective?

        // When

        sut.updateObjective(newObjective: .fixture()) { result in
            actualResult = try? result.get()
        }

        // Then

        XCTAssertNotNil(actualResult)
    }
}

// MARK: - Testing doubles

final class LibraryRemoteServiceStub: LibraryRemoteServiceProtocol {
    var resultToUse: Result<Data, ApiError> = .failure(.unknown)
    
    func learningObjectives(using strandId: String, completion: @escaping Completion) {
        completion(resultToUse)
    }
    
    func newObjectiveMetadata(goalId: String, completion: @escaping Completion) {
        completion(resultToUse)
    }
    
    func createObjective(using newObjectiveModel: LibraryEndpoint.NewObjectiveModel, completion: @escaping Completion) {
        completion(resultToUse)
    }
    
    func updateObjectiveDescription(objectiveId: String, newDescription: String, completion: @escaping Completion) {
        completion(resultToUse)
    }
    
    func delete(objectiveWithId: String, completion: @escaping Completion) {
        completion(resultToUse)
    }
    
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
