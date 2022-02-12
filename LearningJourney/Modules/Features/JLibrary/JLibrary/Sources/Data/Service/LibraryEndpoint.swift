import Foundation

import CoreNetworking

enum LibraryEndpoint {
    case fetchStrand
    case fetchObjectives(_ goalId: Int)
    case updateObjective(_ objectiveUpdate: UpdateObjectiveModel)
}

extension LibraryEndpoint: ApiEndpoint {
    var path: String {
        switch self {
        case .fetchStrand:
            return "strands"
        case let .fetchObjectives(goalId):
            return "goals/\(goalId)"
        case let .updateObjective(objective):
            return "objective/\(objective.id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchStrand, .fetchObjectives:
            return .get
        case .updateObjective:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchStrand, .fetchObjectives:
            return nil
        case let .updateObjective(model):
            return updateObjectiveBody(model)
        }
    }
    
    private func updateObjectiveBody(_ model: UpdateObjectiveModel) -> Data? {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(model)
        return encoded
    }
}

extension LibraryEndpoint {
    struct UpdateObjectiveModel: Encodable {
        let id: Int
        let newStatus: LearningObjectiveStatus
        let isBookmarked: Bool
    }
}
