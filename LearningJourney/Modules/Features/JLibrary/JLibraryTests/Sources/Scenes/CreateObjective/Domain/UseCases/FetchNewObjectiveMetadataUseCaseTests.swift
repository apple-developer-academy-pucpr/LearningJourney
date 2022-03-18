import XCTest

@testable import JLibrary

final class FetchNewObjectiveMetadataUseCaseTests: XCTestCase {
    // MARK: - Properties

    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = FetchNewObjectiveMetadataUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests

    func test_execute_itShouldFetchMetadata_andComplete() {
        // Given

        let completionExpectation = expectation(description: "Completion should be called")

        // When

        sut.execute(goalId: "dummy") { _ in
            completionExpectation.fulfill()
        }

        // Then

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.fetchNewObjectiveMetadataCallCount, 1)
    }
}
