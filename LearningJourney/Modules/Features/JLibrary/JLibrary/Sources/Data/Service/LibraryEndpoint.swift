import Foundation

import CoreNetworking

enum LibraryEndpoint {
    case fetchStrand
    case fetchObjectives(_ goalId: String)
    case updateObjective(_ objectiveUpdate: UpdateObjectiveModel)
    case createObjective(NewObjectiveModel)
    case newObjectiveMetadata(String)
    case updateObjectiveDescription(String, String)
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
        case let .newObjectiveMetadata(goalId):
            return "objectives/new?goalId=\(goalId)"
        case let .updateObjectiveDescription(objectiveId, _):
            return "objectives/\(objectiveId)/description"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchStrand, .fetchObjectives, .newObjectiveMetadata:
            return .get
        case .updateObjective, .createObjective, .updateObjectiveDescription:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchStrand, .fetchObjectives, .newObjectiveMetadata:
            return nil
        case let .updateObjective(model):
            return jsonEncoded(model)
        case let .createObjective(newObjectiveModel):
            return jsonEncoded(newObjectiveModel)
        case let .updateObjectiveDescription(_, newDescription):
            return jsonEncoded([ "description": newDescription ])
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
