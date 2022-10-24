import XCTest

@testable import JLibrary

final class ToggleEagerToLearnUseCaseTests: XCTestCase {
    
    func test_execute_itShouldToggleEagerToLearn_andCallRepository() {
        // Given
        
        let repository = LibraryRepositorySpy()
        let sut = ToggleEagerToLearnUseCase(repository: repository)
        let bookmarkStub = Bool.random()
        let expectedBookmark = !bookmarkStub
        let objective: LearningObjective = .fixture(isBookmarked: bookmarkStub)
        let expectation = expectation(description: "must call callback")
        
        // When
        
        sut.execute(objective: objective) { _ in
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repository.updateObjectiveCallCount, 1)
        XCTAssertEqual(expectedBookmark, repository.updateObjectiveNewObjectivePassed?.isBookmarked)
    }
}
