import Foundation

struct LearningStrand: Decodable, Identifiable, Equatable {
    
    let id: String
    let name: String
    let goals: [LearningGoal]
}
