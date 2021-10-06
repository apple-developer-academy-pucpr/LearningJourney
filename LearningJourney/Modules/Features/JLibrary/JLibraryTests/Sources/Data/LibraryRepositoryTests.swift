import XCTest
@testable import JLibrary

final class LibraryRepositoryTests: XCTestCase {
    // MARK: - Properties

    private var libraryRemoteServiceSpy = LibraryRemoteServiceSpy()
    private var libraryParsingStub = LibraryParsingStub()
    private lazy var sut = LibraryRepository(remoteService: libraryRemoteServiceSpy, parser: libraryParsingStub)

    // MARK: - Unit tests

    func test_fetchStrands_itShouldHandleParsingErrors() {
        // Given

        let fetchShouldFail = true
        var didReturnError = !fetchShouldFail

        // When

        sut.fetchStrands { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                didReturnError = true
            }
        }

        // Then

        XCTAssertEqual(didReturnError, fetchShouldFail)
    }

    func test_fetchStrands_itShouldParsePayload() {
        // Given

        let fetchShouldFail = false
        var didReturnError = !fetchShouldFail
        libraryParsingStub.successToUse = [LearningStrand]()

        // When

        sut.fetchStrands { result in
            switch result {
            case .success(_):
                didReturnError = false
            case .failure(_):
                break
            }
        }

        // Then

        XCTAssertEqual(didReturnError, fetchShouldFail)
    }

    func test_fetchObjectives_itShould() {
        // Given

        // When

        // Then
    }
}

// MARK: - Testing doubles

final class LibraryRemoteServiceSpy: LibraryRemoteServiceProtocol {
    func learningStrands(completion: @escaping Completion) {
        completion(.success(.init()))
    }

    
    func learningObjectives(using strandId: Int, completion: @escaping Completion) {
        fatalError("not implemented")
    }

    func updateObjective(using objective: LibraryEndpoint.UpdateObjectiveModel, completion: @escaping Completion) {
        fatalError("not implemented")
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
