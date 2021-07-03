import Foundation

struct LearningGoal: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let progress: Double
}
