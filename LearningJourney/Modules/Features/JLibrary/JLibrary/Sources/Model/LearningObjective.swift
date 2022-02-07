import Foundation

enum LearningObjectiveType: String, Decodable {
    case core
    case elective
    case custom
}

enum LearningObjectiveStatus: String, Codable {
    case untutored
    case learning
    case learned
    case mastered
}

struct LearningObjective: Decodable, Identifiable, Equatable {
    let id: Int
    let code: String
    let description: String
    let type: LearningObjectiveType
    let status: LearningObjectiveStatus
}
