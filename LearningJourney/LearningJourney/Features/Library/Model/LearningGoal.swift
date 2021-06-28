import Foundation

struct LearningGoal: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let progress: Double
}
