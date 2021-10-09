//
//  ToggleLearnUseCaseSpy.swift
//  JLibraryTests
//
//  Created by Maria Fernanda Azolin on 08/10/21.
//

import Foundation
@testable import JLibrary

public final class ToggleLearnUseCaseSpy: ToggleLearnUseCaseProtocol {
    
    public init() {}
    
    public var resultToUse: Result<LearningObjective, LibraryRepositoryError> = .failure(.unknown)
    public private(set) var objectivePassed: LearningObjective?
    public private(set) var executeCalled = false
    
    public func execute(objective: LearningObjective, then handle: @escaping Completion) {
        executeCalled = true
        objectivePassed = objective
        handle(resultToUse)
    }
}
