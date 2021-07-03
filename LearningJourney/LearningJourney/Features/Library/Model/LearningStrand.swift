import Foundation

struct LearningStrand: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let goals: [LearningGoal]
}
