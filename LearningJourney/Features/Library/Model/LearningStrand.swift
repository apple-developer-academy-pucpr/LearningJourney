import Foundation

struct LearningStrand: Decodable, Identifiable {
    var id = UUID()
    
    let name: String
    let goals: [LearningGoal]
    
    enum CodingKeys: String, CodingKey {
        case name, goals
    }
}
