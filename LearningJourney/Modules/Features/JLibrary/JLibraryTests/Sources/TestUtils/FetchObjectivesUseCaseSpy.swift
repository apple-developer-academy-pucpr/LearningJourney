@testable import JLibrary

final class FetchObjectivesUseCaseSpy: FetchObjectivesUseCaseProtocol {
    
    init() {}
    
    var objectiveToUse: Result<[LearningObjective], LibraryRepositoryError> = .failure(.unknown)
    private(set) var learningGoalPassed: LearningGoal?
    private(set) var executeCallCount = 0
    
    func execute(using learningGoal: LearningGoal, then handle: @escaping Completion) {
        executeCallCount += 1
        learningGoalPassed = learningGoal
        handle(objectiveToUse)
    }
}
