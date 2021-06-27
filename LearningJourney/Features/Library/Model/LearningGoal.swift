import Foundation

struct LearningGoal: Decodable, Identifiable {
    var id = UUID()
    
    let name: String
    let progress: Double
    
    enum CodingKeys: String, CodingKey {
        case name, progress
    }
}
