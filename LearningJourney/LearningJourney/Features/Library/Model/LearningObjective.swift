import Foundation

struct LearningObjective: Decodable, Identifiable, Equatable {
    let id: String
    let isCore: Bool
    let Description: String
    let isLearned: Bool
    
    internal init(id: String, isCore: Bool, Description: String, isLearned: Bool) {
        self.id = id
        self.isCore = isCore
        self.Description = Description
        self.isLearned = isLearned
    }
    
}
