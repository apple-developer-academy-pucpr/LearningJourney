import Foundation

struct LearningObjective: Decodable, Identifiable, Equatable {
    let id: Int
    let code: String
    let description: String
    let isCore: Bool
    let isComplete: Bool
}
