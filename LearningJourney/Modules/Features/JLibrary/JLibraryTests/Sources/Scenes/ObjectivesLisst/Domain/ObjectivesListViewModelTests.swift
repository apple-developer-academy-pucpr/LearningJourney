import TestingUtils
import XCTest

@testable import JLibrary

final class ObjectivesListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private let fetchObjectivesUseCaseSpy = FetchObjectivesUseCaseSpyStub()
    private let toggleLearnUseCaseSpy = ToggleLearnUseCaseSpyStub()
    private let goalMock: LearningGoal = .fixture()
    
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

        let expectedLearningGoal = LearningGoal.fixture()
        XCTAssertEqual(fetchObjectivesUseCaseSpy.learningGoalPassed, expectedLearningGoal)
    }
    
    func test_handleOnAppear_whenObjectivesAreAlreadyLoading_shouldCallExecuteOnlyOnce() {
        //Given
        sut.handleOnAppear()
        
        //When
        sut.objectives = .loading
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
        let firstLearningObjectiveDummy = LearningObjective.fixture(id: 1)
        let secondLearningObjectiveStub = LearningObjective.fixture(id: 2)
        
        toggleLearnUseCaseSpy.resultToUse = .success(secondLearningObjectiveStub)
        
        sut.objectives = .result([
            LibraryViewModelState.result(firstLearningObjectiveDummy),
            LibraryViewModelState.result(secondLearningObjectiveStub)
        ])
        
        //When
        sut.handleDidLearnToggled(
            objective: LibraryViewModelState.result(secondLearningObjectiveStub)
        )
        
        //Then
        XCTAssertEqual(toggleLearnUseCaseSpy.objectivePassed?.id, 2)
    }
    
    func test_handleDidLearnToggled_whenObjectivesArrayIsEmpty_shouldNotCallExecute() {
        //Given
        let learningObjective = LearningObjective.fixture(id: 1)
        toggleLearnUseCaseSpy.resultToUse = .success(learningObjective)
        sut.objectives = .result([])
                
        //When
        sut.handleDidLearnToggled(
            objective: LibraryViewModelState.result(learningObjective)
        )
        
        //Then
        XCTAssertFalse(toggleLearnUseCaseSpy.executeCalled)
    }
}
