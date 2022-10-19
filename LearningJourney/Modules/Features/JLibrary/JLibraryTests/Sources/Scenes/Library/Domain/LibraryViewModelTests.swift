import XCTest
@testable import JLibrary

final class LibraryViewModelTests: XCTestCase {

    // MARK: - Properties

    private let analyticsLoggerSpy = AnalyticsLoggerSpy()
    private let fetchStrandsSpy = FetchStrandsSpy()
    private lazy var fetchStrandsUseCase = FetchStrandsUseCaseMock(spy: fetchStrandsSpy)
    private let signoutUseCase = SignoutUseCaseMock()

    private lazy var sut = LibraryViewModel(
        useCases: .init(
            fetchStrandsUseCase: fetchStrandsUseCase,
            signoutUseCase: signoutUseCase
        ), analyticsLogger: analyticsLoggerSpy
    )

    // MARK: - Unit tests

    func test_handleOnAppear_whenResultSucceeds_strandsAreLoaded() {
        // Given
        fetchStrandsUseCase.resultToUse = .success([])

        // When
        sut.handleOnAppear()

        // Then
        XCTAssertEqual(sut.strands, .result([]))
        XCTAssertEqual(1, analyticsLoggerSpy.logCallCount)
    }

    func test_handleOnAppear_whenResultFails_strandsAreSetToError() {
        // Given
        fetchStrandsUseCase.resultToUse = .failure(.unauthorized)

        // When
        sut.handleOnAppear()

        // Then
        XCTAssertEqual(sut.strands, .error(.notAuthenticated))
    }

    func test_handleOnAppear_whenAlreadyLoading_secondCallIgnored() {
        // Given
        fetchStrandsUseCase.shouldHandle = false
        sut.handleOnAppear()

        // When
        fetchStrandsUseCase.shouldHandle = true
        sut.handleOnAppear()

        // Then
        XCTAssertEqual(fetchStrandsSpy.executeCount, 1)
    }

    func test_handleUserDidChange_whenResultSucceeds_strandsChanged() {
        // Given
        fetchStrandsUseCase.resultToUse = .success([])
        sut.handleOnAppear()

        // When
        fetchStrandsUseCase.resultToUse = .success([LearningStrand.fixture()])
        sut.handleUserDidChange()

        // Then
        XCTAssertEqual(sut.strands, .result([LearningStrand.fixture()]))
    }

    func test_handleSignout_signoutUseCaseExecuted() {
        // Given / When
        sut.handleSignout()

        // Then
        XCTAssertTrue(signoutUseCase.executed)
    }
    
    func test_togglePresentationMode_itShouldToggleListState_andLogEvent() {
        // Given
        let previousListState = sut.isList
        let expectedListFlag = !previousListState
        
        // When
        sut.togglePresentationMode()
        
        // Then
        XCTAssertEqual(sut.isList, expectedListFlag)
        XCTAssertEqual(1, analyticsLoggerSpy.logCallCount)
    }
}

final class FetchStrandsUseCaseMock: FetchStrandsUseCaseProtocol {

    var resultToUse: Result<[LearningStrand], LibraryRepositoryError> = .failure(.unknown)
    var shouldHandle = true

    let spy: FetchStrandsSpy
    init(spy: FetchStrandsSpy) {
        self.spy = spy
    }

    func execute(then handle: @escaping Completion) {
        spy.executeCount += 1
        guard shouldHandle else { return }
        handle(resultToUse)
    }
}

final class FetchStrandsSpy {
    var executeCount = 0
}

final class SignoutUseCaseMock: SignoutUseCaseProtocol {
    var executed = false
    func execute() {
        executed = true
    }
}
