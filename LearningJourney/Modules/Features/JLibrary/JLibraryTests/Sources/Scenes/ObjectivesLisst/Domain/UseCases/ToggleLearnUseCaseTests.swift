import XCTest
@testable import JLibrary

final class ToggleLearnUseCaseTests: XCTestCase {
    // MARK: - Properties
    
    private let libraryRepositorySpy = LibraryRepositorySpy()
    private lazy var sut = ToggleLearnUseCase(repository: libraryRepositorySpy)

    // MARK: - Unit tests
    
    func test_execute_itShouldFlipLearnedFlag() {
        // Given

        let expectedFlag = LearningObjectiveStatus.learning

        let completionExpectation = expectation(description: "Completion should be called")
        
        // When
        
        sut.execute(objective: .fixture(status: .untutored)) { _ in
            completionExpectation.fulfill()
        }

        // Then
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(libraryRepositorySpy.updateObjectiveCallCount, 1)
        XCTAssertEqual(expectedFlag, libraryRepositorySpy.updateObjectiveNewObjectivePassed?.status)
    }
}

// MARK: - Testing doubles

final class LibraryRepositorySpy: LibraryRepositoryProtocol  {
    private(set) var fetchNewObjectiveMetadataCallCount = 0
    func fetchNewObjectiveMetadata(goalId: String, completion: @escaping Completion<NewObjectiveMetadata>) {
        fetchNewObjectiveMetadataCallCount += 1
        completion(.success(.fixture()))
        
    }
    
    private(set) var createObjectiveCallCount = 0
    func createObjective(goalId: String, description: String, completion: @escaping Completion<LearningObjective>) {
        createObjectiveCallCount += 1
        completion(.failure(.unauthorized))
    }
    
    private(set) var updateObjectiveDescriotionCallCount = 0
    func updateObjectiveDescription(objective: LearningObjective, newDescription: String, completion: @escaping Completion<LearningObjective>) {
        updateObjectiveDescriotionCallCount += 1
        completion(.success(.fixture()))
    }
    
    private(set) var deleteCallCount = 0
    func delete(objective: LearningObjective, completion: @escaping Completion<Void>) {
        deleteCallCount += 1
        completion(.failure(.unauthorized))
    }
    
    private(set) var fetchStrandsCallCount = 0
    func fetchStrands(completion: @escaping Completion<[LearningStrand]>) {
        fetchStrandsCallCount += 1
        completion(.failure(.unknown))
    }

    private(set) var fetchObjectivesCallCount = 0
    func fetchObjectives(using goal: LearningGoal, completion: @escaping Completion<[LearningObjective]>) {
        fetchObjectivesCallCount += 1
        completion(.failure(.unknown))
    }

    private(set) var updateObjectiveCallCount = 0
    private(set) var updateObjectiveNewObjectivePassed: LearningObjective?
    func updateObjective(newObjective: LearningObjective, completion: @escaping Completion<LearningObjective>) {
        updateObjectiveCallCount += 1
        updateObjectiveNewObjectivePassed = newObjective
        completion(.failure(.unknown))
    }
}

extension NewObjectiveMetadata {
    static func fixture(strandName: String = .init(),
                        goalName: String = .init(),
                        code: String = .init()
    ) -> Self {
        .init(
            strandName: strandName,
            goalName: goalName,
            code: code)
    }
}
