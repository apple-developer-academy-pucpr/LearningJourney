//
//  ObjectiveCardViewModel.swift
//  JLibrary
//
//  Created by Bruno Pastre on 16/02/22.
//

import Foundation

struct LearningStatusButtonState: Equatable {
    let name: String
    let imageName: String
    let learningStatusButtonStyle: LearningStatusButtonStyle
}

protocol ObjectiveCardViewModelProtocol: ObservableObject {

    var objectiveDescription: String { get }
    var objectiveCode: String { get }
    var objectiveType: String { get }
    var isBookmarked: Bool { get }
    var canShowEditingBar: Bool { get }
    
    var buttonState: LibraryViewModelState<LearningStatusButtonState> { get }
    func handleLearnStatusToggled()
    func handleWantToLearnToggled()
}

final class ObjectiveCardViewModel: ObjectiveCardViewModelProtocol {
    struct UseCases {
        let toggleLearnUseCase: ToggleLearnUseCaseProtocol
        let toggleEagerToLearnUseCase: ToggleEagerToLearnUseCaseProtocol
    }
    
    @Published
    private(set) var objectiveDescription: String = ""
    @Published
    private(set) var objectiveCode: String = ""
    @Published
    private(set) var objectiveType: String = ""
    @Published
    private(set) var isBookmarked: Bool = false
    @Published
    private(set) var buttonState: LibraryViewModelState<LearningStatusButtonState> = .loading
    
    var canShowEditingBar: Bool { objective.type == .custom }
    
    
    private let useCases: UseCases
    private var objective: LearningObjective {
        didSet {
            renderObjective()
        }
    }
    
    init(useCases: UseCases, objective: LearningObjective) {
        self.useCases = useCases
        self.objective = objective
        renderObjective()
    }
    
    func handleLearnStatusToggled() {
        buttonState = .loading
        useCases.toggleLearnUseCase.execute(objective: objective) { [weak self] in
            switch $0 {
            case let .success(objective):
                self?.objective = objective
            case .failure:
                self?.renderObjective()
            }
        }
    }
    
    
    func handleWantToLearnToggled() {
        buttonState = .loading
        useCases.toggleEagerToLearnUseCase.execute(objective: objective) { [weak self] in
            switch $0 {
            case let .success(objective):
                self?.objective = objective
            case .failure:
                self?.renderObjective()
            }
        }
    }
    
    private var buttonName: String {
        switch objective.status {
        case .untutored where objective.isBookmarked:
            return "Quero Aprender"
        case .untutored:
            return "Não sei"
        case .learning:
            return "Aprendendo"
        case .learned:
            return "Aprendi"
        case .mastered:
            return "Sei ensinar"
        }
    }
    
    private var buttonImageName: String {
        switch objective.status {
        case .untutored where objective.isBookmarked:
            return "circle"
        case .untutored:
            return ""
        case .learning:
            return "circle.lefthalf.filled"
        case .learned:
            return "circle.fill"
        case .mastered:
            return "diamond.fill"
        }
    }
    
    private var objectiveTypeName: String {
        switch objective.type {
        case .core:
            return "Core"
        case .elective:
            return "Elective"
        case .custom:
            return "Authoral"
        }
    }
    
    private var learningButtonStyle: LearningStatusButtonStyle {
        .init(status: objective.status, isBookmarked: objective.isBookmarked)
    }
    
    private func renderObjective() {
        objectiveDescription = objective.description
        objectiveCode = objective.code
        objectiveType = objectiveTypeName
        isBookmarked = objective.isBookmarked
        buttonState = .result(.init(name: buttonName,
                                    imageName: buttonImageName,
                                    learningStatusButtonStyle: learningButtonStyle))
    }
}
