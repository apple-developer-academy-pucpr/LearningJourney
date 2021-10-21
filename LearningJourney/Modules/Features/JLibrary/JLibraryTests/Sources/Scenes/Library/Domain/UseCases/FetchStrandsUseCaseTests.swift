import XCTest
@testable import JLibrary

final class FetchStrandsUseCaseTests: XCTestCase {
    // MARK: - Properties

    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = FetchStrandsUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests

    func test_execute_itShouldFetchStrands() {
        // Given

        let completionExpectation = expectation(description: "Completion should be called")

        // When

        sut.execute { _ in
            completionExpectation.fulfill()
        }

        // Then

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.fetchStrandsCallCount, 1)
    }
}
