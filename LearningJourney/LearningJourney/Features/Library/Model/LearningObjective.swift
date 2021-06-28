import Foundation

struct LearningObjective: Decodable, Identifiable, Equatable {
    let id: String
    let isCore: Bool
    let Description: String
    let isLearned: Bool
}
