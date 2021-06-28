import Foundation

enum LibraryEndpoint {
    case fetchStrand
    case fetchObjectives(_ goalId: String)
    case updateObjective(_ objectiveUpdate: UpdateObjectiveModel)
}

extension LibraryEndpoint: ApiEndpoint {
    var path: String {
        switch self {
        case .fetchStrand:
            return "8e2c6d83-a07d-490a-9405-bc7d3b7fe83e"
//            return "strands/"
        case let .fetchObjectives(goalId):
            return "d54f2d6f-4ec8-427d-b70a-0b02510ea6c4"
            return "goal/\(goalId)"
        case let .updateObjective(objectiveId):
            return "objective/\(objectiveId)"
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
        let id: String
        let description: String
        let isCore: Bool
        let isLearned: Bool
        
        enum CodingKeys: String, CodingKey {
            case description, isCore, isLearned
        }
    }
}
