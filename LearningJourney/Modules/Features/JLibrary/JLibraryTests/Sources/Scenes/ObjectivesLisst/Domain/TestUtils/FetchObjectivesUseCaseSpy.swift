//
//  FetchObjectivesUseCaseSpy.swift
//  JLibraryTests
//
//  Created by Maria Fernanda Azolin on 08/10/21.
//

import Foundation
@testable import JLibrary

final class FetchObjectivesUseCaseSpy: FetchObjectivesUseCaseProtocol {
    
    var objectiveToUse: Result<[LearningObjective], LibraryRepositoryError> = .failure(.unknown)
    var shouldHandle = true
    private(set) var learningGoalPassed: LearningGoal?
    private(set) var executeCallCount = 0
    
    func execute(using learningGoal: LearningGoal, then handle: @escaping Completion) {
        executeCallCount += 1
        guard shouldHandle else { return }
        
        learningGoalPassed = learningGoal
        handle(objectiveToUse)
    }
}
