//
//  ObjectivesListViewModelTests.swift
//  JLibraryTests
//
//  Created by Maria Fernanda Azolin on 08/10/21.
//

import XCTest
@testable import JLibrary

final class ObjectivesListViewModelTests: XCTestCase {
    
    private let fetchObjectivesUseCaseSpy = FetchObjectivesUseCaseSpy()
    private let toggleLearnUseCaseSpy = ToggleLearnUseCaseSpy()
    private let goalMock: LearningGoal = .init(id: 1, name: "goal", progress: 0.0)
    
    private lazy var sut = ObjectivesListViewModel(
        useCases: .init(
            fetchObjectivesUseCase: fetchObjectivesUseCaseSpy,
            toggleLearnUseCase: toggleLearnUseCaseSpy
        ),
        dependencies: .init(goal: goalMock)
    )
    
    // MARK: - handleOnAppear
    
    func test_handleOnAppear_whenResultIsSuccess_shouldCorrectlyLoadObjectives() {
        //Given
        fetchObjectivesUseCaseSpy.objectiveToUse = .success([])
        
        //When
        sut.handleOnAppear()
        
        //Then
        XCTAssertEqual(sut.objectives, .result([]))
        
        let learningGoal = LearningGoal.init(id: 1, name: "goal", progress: 0)
        XCTAssertEqual(fetchObjectivesUseCaseSpy.learningGoalPassed, learningGoal)
    }
    
    func test_handleOnAppear_whenObjectivesAreAlreadyLoading_shouldCallExecuteOnlyOnce() {
        //Given
        fetchObjectivesUseCaseSpy.shouldHandle = false
        
        //When
        sut.handleOnAppear()
        sut.handleOnAppear()
        
        //Then
        XCTAssertEqual(fetchObjectivesUseCaseSpy.executeCallCount, 1)
    }
    
    func test_handleOnAppear_whenResultFailsWithUnauthorizedError_shouldHaveNotAuthenticatedError() {
        //Given
        fetchObjectivesUseCaseSpy.objectiveToUse = .failure(.unauthorized)
        
        //When
        sut.handleOnAppear()
        
        //Then
        XCTAssertEqual(sut.objectives, .error(.notAuthenticated))
    }
    
    func test_handleOnAppear_whenResultFailsWithUnknownError_shouldHaveUnknownError() {
        //Given
        fetchObjectivesUseCaseSpy.objectiveToUse = .failure(.unknown)
        
        //When
        sut.handleOnAppear()
        
        //Then
        XCTAssertEqual(sut.objectives, .error(.unknown({})))
    }
    
    func test_handleOnAppear_whenResultFailsWithApiError_shouldHaveUnknownError() {
        //Given
        fetchObjectivesUseCaseSpy.objectiveToUse = .failure(.api(.notAllowed))
        
        //When
        sut.handleOnAppear()
        
        //Then
        XCTAssertEqual(sut.objectives, .error(.unknown({})))
    }
    
    func test_handleOnAppear_whenResultFailsWithParsingError_shouldHaveUnknownError() {
        //Given
        fetchObjectivesUseCaseSpy.objectiveToUse = .failure(
            .parsing(
                .invalidData(DummyError.dummy)
            )
        )

        //When
        sut.handleOnAppear()

        //Then
        XCTAssertEqual(sut.objectives, .error(.unknown({})))
    }
    
    // MARK: - handleDidLearnToggled
    
    func test_handleDidLearnToggled_shouldPassCorrectObjective() {
        //Given
        let firstLearningObjective = createLearningObjective(id: 1)
        let secondLearningObjective = createLearningObjective(id: 2)
        
        toggleLearnUseCaseSpy.resultToUse = .success(secondLearningObjective)
        
        sut.objectives = .result([
            LibraryViewModelState.result(firstLearningObjective),
            LibraryViewModelState.result(secondLearningObjective)
        ])
        
        //When
        sut.handleDidLearnToggled(
            objective: LibraryViewModelState.result(secondLearningObjective)
        )
        
        //Then
        XCTAssertEqual(toggleLearnUseCaseSpy.objectivePassed?.id, 2)
    }
    
    func test_handleDidLearnToggled_whenObjectivesArrayIsEmpty_shouldNotCallExecute() {
        //Given
        let learningObjective = createLearningObjective(id: 1)
        toggleLearnUseCaseSpy.resultToUse = .success(learningObjective)
        sut.objectives = .result([])
                
        //When
        sut.handleDidLearnToggled(
            objective: LibraryViewModelState.result(learningObjective)
        )
        
        //Then
        XCTAssertFalse(toggleLearnUseCaseSpy.executeCalled)
    }
    
    // MARK: - Helper functions
    
    private func createLearningObjective(id: Int) -> LearningObjective {
        LearningObjective(
            id: id,
            code: "code",
            description: "description",
            isCore: Bool.random(),
            isComplete: Bool.random()
        )
    }
}
