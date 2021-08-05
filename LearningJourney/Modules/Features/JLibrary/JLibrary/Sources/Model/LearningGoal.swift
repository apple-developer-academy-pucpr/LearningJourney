import Foundation

public struct LearningGoal: Decodable, Identifiable, Equatable {
    public let id: Int
    let name: String
    let progress: Double
}
