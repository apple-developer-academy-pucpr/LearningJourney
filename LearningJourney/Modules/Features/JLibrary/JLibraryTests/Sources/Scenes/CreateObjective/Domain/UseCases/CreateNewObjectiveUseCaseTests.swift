
import XCTest

@testable import JLibrary

final class CreateNewObjectiveUseCaseTests: XCTestCase {
    // MARK: - Properties

    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = CreateNewObjectiveUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests

    func test_execute_itShouldCreateObjectiveInRepository_thenCallCompletion() {
        // Given

        let completionExpectation = expectation(description: "Completion should be called")

        // When

        sut.execute(goalId: "dummy", description: "dummy") { _ in
            completionExpectation.fulfill()
        }

        // Then

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.createObjectiveCallCount, 1)
    }
}
