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
