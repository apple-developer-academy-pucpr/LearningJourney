import Foundation

struct LearningObjective: Decodable, Identifiable, Equatable {
    let id: Int
    let code: String
    let description: String
    let isCore: Bool
    let isComplete: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case description
        case isCore
        case isComplete
    }
}
