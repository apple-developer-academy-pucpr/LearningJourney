import XCTest
@testable import JLibrary

final class FetchObjectivesUseCaseTests: XCTestCase {
    // MARK: - Properties

    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = FetchObjectivesUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests

    func test_execute_itShouldFetchObjectives() {
        // Given

        let learningGoal: LearningGoal = .fixture()

        let completionExpectation = expectation(description: "Completion should be called")

        // When

        sut.execute(using: learningGoal) { _ in
            completionExpectation.fulfill()
        }

        // Then

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.fetchObjectivesCallCount, 1)
    }
    
}

// MARK: - Testing doubles

fileprivate final class LibraryRepositorySpy: LibraryRepositoryProtocol  {
    func fetchStrands(completion: @escaping Completion<[LearningStrand]>) {
        fatalError("not implemented")
    }

    private(set) var fetchObjectivesCallCount = 0
    func fetchObjectives(using goal: LearningGoal, completion: @escaping Completion<[LearningObjective]>) {
        fetchObjectivesCallCount += 1
        completion(.failure(.unknown))
    }

    func updateObjective(newObjective: LearningObjective, completion: @escaping Completion<LearningObjective>) {
        fatalError("not implemented")
    }
}
