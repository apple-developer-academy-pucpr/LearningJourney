import XCTest

@testable import JLibrary

final class UpdateObjectiveDescriptionUseCaseTests: XCTestCase {
    
    func test_execute_itShouldCallRepository() {
        // Given
        
        let repository = LibraryRepositorySpy()
        let sut = UpdateObjectiveDescriptionUseCase(repository: repository)
        let expectation = expectation(description: "must call callback")
        
        // When
        
        sut.execute(objective: .fixture(), newDescription: "dummy") { _ in
            expectation.fulfill()
        }
        
        // Then
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repository.updateObjectiveDescriotionCallCount, 1)
    }
}
