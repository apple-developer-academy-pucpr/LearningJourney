import TestingUtils
import XCTest
import CoreTracking

@testable import JLibrary

final class ObjectivesListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private let analyticsLogger = AnalyticsLogger()
    private let fetchObjectivesUseCaseSpy = FetchObjectivesUseCaseSpyStub()
    private let toggleLearnUseCaseSpy = ToggleLearnUseCaseSpyStub()
    private let goalMock: LearningGoal = .fixture()
    
    private lazy var sut = ObjectivesListViewModel(
        useCases: .init(
            fetchObjectivesUseCase: fetchObjectivesUseCaseSpy
        ),
        dependencies: .init(goal: goalMock),
        analyticsLogger: analyticsLogger
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
}

final class AnalyticsLoggerSpy: AnalyticsLogging {
    var logCallCount: Int { logEventsPassed.count }
    private(set) var logEventsPassed: [AnalyticsEvent] = []
    func log(event: AnalyticsEvent) {
        logEventsPassed.append(event)
    }
}
