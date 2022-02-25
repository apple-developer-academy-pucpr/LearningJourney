import Foundation

import CoreNetworking

enum LibraryEndpoint {
    case fetchStrand
    case fetchObjectives(_ goalId: String)
    case updateObjective(_ objectiveUpdate: UpdateObjectiveModel)
    case createObjective(NewObjectiveModel)
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
        case .createObjective:
            return "objectives/create"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchStrand, .fetchObjectives:
            return .get
        case .updateObjective, .createObjective:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchStrand, .fetchObjectives:
            return nil
        case let .updateObjective(model):
            return jsonEncoded(model)
        case let .createObjective(newObjectiveModel):
            return jsonEncoded(newObjectiveModel)
        }
    }
    
    private func jsonEncoded<Model>(_ model: Model) -> Data? where Model: Encodable {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(model)
        return encoded
    }
}

extension LibraryEndpoint {
    struct UpdateObjectiveModel: Encodable {
        let id: String
        let newStatus: LearningObjectiveStatus
        let isBookmarked: Bool
    }
    
    struct NewObjectiveModel: Encodable {
        let description: String
        let goalId: String
    }
}
