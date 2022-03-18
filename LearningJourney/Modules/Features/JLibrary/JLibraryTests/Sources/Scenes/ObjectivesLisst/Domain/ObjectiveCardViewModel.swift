import TestingUtils
import XCTest

@testable import JLibrary

final class ObjectiveCardViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private let toggleLearnUseCaseStub = ToggleLearnUseCaseSpyStub()
    private let toggleEagerToLearnUseCaseStub = ToggleEagerToLearnUseCaseStub()
    private let updateObjectiveDescriptionUseCaseStub = UpdateObjectiveDescriptionUseCaseStub()
    private let deleteObjectiveUseCaseStub = DeleteObjectiveUseCaseStub()
    
    // MARK: - Unit tests
    
    func test_handleLearnStatusToggled_whenCantEditDescription_itShouldReturn() {
        // Given
        
        let sut = makeSut()
        sut.buttonState = .empty
        sut.canEditDescription = true
        
        // When
        
        sut.handleLearnStatusToggled()
        
        // Then
        XCTAssertEqual(sut.buttonState, .empty)
        
    }
    
    func test_handleLearnStatusToggled_whenUseCaseSucceeds_itShouldUpdateObjective() {
        // Given
        
        let sut = makeSut()
        let expectedDescription = UUID().uuidString
        sut.objectiveDescription = "not expected"
        toggleLearnUseCaseStub.resultToUse = .success(.fixture(description: expectedDescription))
        
        // When
        
        sut.handleLearnStatusToggled()
        
        // Then
        
        XCTAssertEqual(sut.objectiveDescription, expectedDescription)
    }
    
    func test_handleLearnStatusToggled_whenUseCaseFails_itShouldRenderOldObjective() {
        // Given
        let expectedDescription = UUID().uuidString
        let sut = makeSut(using: .fixture(description: expectedDescription))
        
        toggleLearnUseCaseStub.resultToUse = .failure(.unknown)
        
        // When
        
        sut.handleLearnStatusToggled()
        
        // Then
        
        XCTAssertEqual(sut.objectiveDescription, expectedDescription)
    }
    
    func test_handleWantToLearnToggled_whenCantEditDescription_itShouldReturn() {
        // Given
        
        let sut = makeSut()
        sut.buttonState = .empty
        sut.canEditDescription = true
        
        // When
        
        sut.handleWantToLearnToggled()
        
        // Then
        XCTAssertEqual(sut.buttonState, .empty)
        
    }
    
    func test_handleWantToLearnToggled_whenUseCaseSucceeds_itShouldUpdateObjective() {
        // Given
        
        let sut = makeSut()
        let expectedDescription = UUID().uuidString
        sut.objectiveDescription = "not expected"
        toggleEagerToLearnUseCaseStub.resultToUse = .success(.fixture(description: expectedDescription))
        
        // When
        
        sut.handleWantToLearnToggled()
        
        // Then
        
        XCTAssertEqual(sut.objectiveDescription, expectedDescription)
    }
    
    func test_handleWantToLearnToggled_whenUseCaseFails_itShouldRenderOldObjective() {
        // Given
        let expectedDescription = UUID().uuidString
        let sut = makeSut(using: .fixture(description: expectedDescription))
        
        toggleEagerToLearnUseCaseStub.resultToUse = .failure(.unknown)
        
        // When
        
        sut.handleWantToLearnToggled()
        
        // Then
        
        XCTAssertEqual(sut.objectiveDescription, expectedDescription)
    }
    
    func test_didStartEditing_itShouldAllowDescriptionEditing() {
        // Given
        
        let sut = makeSut()
        sut.canEditDescription = false
        
        // When
        
        sut.didStartEditing()
        
        // Then
        
        XCTAssertTrue(sut.canEditDescription)
    }
    
    func test_didCancelEditing_itShouldDisallowDescriptionEditing() {
        // Given
        
        let sut = makeSut()
        sut.canEditDescription = true
        
        // When
        
        sut.didCancelEditing()
        
        // Then
        
        XCTAssertFalse(sut.canEditDescription)
    }
    
    func test_didConfirmEditing_whenUseCaseSucceeds_itShouldBlockEditing_andUpdateObjectiveWithUseCase() {
        // Given
        let expectedDescription = UUID().uuidString
        let sut = makeSut()
        sut.canEditDescription = true
        updateObjectiveDescriptionUseCaseStub.resultToUse = .success(.fixture(description: expectedDescription))
        
        // When
        
        sut.didConfirmEditing()
        
        // Then
        
        XCTAssertFalse(sut.canEditDescription)
        XCTAssertEqual(expectedDescription, sut.objectiveDescription)
    }
    
    func test_didConfirmEditing_whenUseCaseFails_itShouldUpdateObjectiveWithUseCase() {
        // Given
        let expectedDescription = UUID().uuidString
        let sut = makeSut(using: .fixture(description: expectedDescription))
        sut.canEditDescription = true
        updateObjectiveDescriptionUseCaseStub.resultToUse = .failure(DummyError.dummy)
        
        // When
        
        sut.didConfirmEditing()
        
        // Then
        
        XCTAssertFalse(sut.canEditDescription)
        XCTAssertEqual(expectedDescription, sut.objectiveDescription)
    }
    
    func test_didConfirmDeletion_whenUseCaseSucceeds_itShouldBlockEditing_andMarkAsDeleted() {
        // Given
        let sut = makeSut()
        sut.canEditDescription = true
        deleteObjectiveUseCaseStub.resultToUse = .success(())
        
        // When
        
        sut.didConfirmDeletion()
        
        // Then
        
        XCTAssertFalse(sut.canEditDescription)
        XCTAssertTrue(sut.isDeleted)
    }
    
    // MARK: - Helpers
    
    private func makeSut(using objective: LearningObjective = .fixture()) -> ObjectiveCardViewModel {
        ObjectiveCardViewModel(
           useCases: .init(
               toggleLearnUseCase: toggleLearnUseCaseStub,
               toggleEagerToLearnUseCase: toggleEagerToLearnUseCaseStub,
               updateObjectiveDescriptionUseCase: updateObjectiveDescriptionUseCaseStub,
               deleteObjectiveUseCase: deleteObjectiveUseCaseStub),
           objective: objective)
    }
}

final class ToggleEagerToLearnUseCaseStub: ToggleEagerToLearnUseCaseProtocol {
    var resultToUse: Result<LearningObjective, LibraryRepositoryError> = .failure(.unknown)
    func execute(objective: LearningObjective, then handle: @escaping Completion) {
        handle(resultToUse)
    }
}

final class UpdateObjectiveDescriptionUseCaseStub: UpdateObjectiveDescriptionUseCaseProtocol {
    var resultToUse: Result<LearningObjective, Error> = .failure(DummyError.dummy)
    func execute(objective: LearningObjective, newDescription: String, completion: @escaping (Result<LearningObjective, Error>) -> Void) {
        completion(resultToUse)
    }
}

final class DeleteObjectiveUseCaseStub: DeleteObjectiveUseCaseProtocol {
    var resultToUse: Result<Void, Error> = .failure(DummyError.dummy)
    func execute(objective: LearningObjective, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(resultToUse)
    }
}
