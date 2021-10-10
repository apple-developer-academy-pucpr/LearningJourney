import XCTest
@testable import JLibrary

final class ToggleLearnUseCaseTests: XCTestCase {
    // MARK: - Properties
    
    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = ToggleLearnUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests
    
    func test_execute_itShouldFlipLearnedFlag() {
        // Given

        let flagStub: Bool = .random()
        let expectedFlag = !flagStub

        let completionExpectation = expectation(description: "Completion should be called")
        
        // When
        
        sut.execute(objective: .fixture(isComplete: flagStub)) { _ in
            completionExpectation.fulfill()
        }

        // Then
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.updateObjectiveCallCount, 1)
        XCTAssertEqual(expectedFlag, libraryRepositorySpy.updateObjectiveNewObjectivePassed?.isComplete)
    }
}

// MARK: - Testing doubles

final class LibraryRepositorySpy: LibraryRepositoryProtocol  {
    func fetchStrands(completion: @escaping Completion<[LearningStrand]>) {
        fatalError("not implemented")
    }

    func fetchObjectives(using goal: LearningGoal, completion: @escaping Completion<[LearningObjective]>) {
        fatalError("not implemented")
    }

    private(set) var updateObjectiveCallCount = 0
    private(set) var updateObjectiveNewObjectivePassed: LearningObjective?
    func updateObjective(newObjective: LearningObjective, completion: @escaping Completion<LearningObjective>) {
        updateObjectiveCallCount += 1
        updateObjectiveNewObjectivePassed = newObjective
        completion(.failure(.unknown))
    }
}
