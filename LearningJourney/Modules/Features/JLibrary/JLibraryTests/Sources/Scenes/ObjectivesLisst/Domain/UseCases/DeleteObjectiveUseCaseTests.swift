import XCTest

@testable import JLibrary

final class DeleteObjectiveUseCaseTests: XCTestCase {
    // MARK: - Properties

    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = DeleteObjectiveUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests

    func test_execute_itShouldFetchObjectives() {
        // Given

        let completionExpectation = expectation(description: "Completion should be called")

        // When

        sut.execute(objective: .fixture()) { _ in
            completionExpectation.fulfill()
        }

        // Then

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.deleteCallCount, 1)
    }
    
}
