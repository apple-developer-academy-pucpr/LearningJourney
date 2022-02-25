import Foundation

public struct LearningGoal: Decodable, Identifiable, Equatable {
    public let id: String
    let name: String
    let progress: Double
}
