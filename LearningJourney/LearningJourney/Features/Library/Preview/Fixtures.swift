#if DEBUG
extension LearningStrand {
    static func fixture(
        id: String = "",
        name: String = "Logic and Programming",
        goals: [LearningGoal] = []
    ) -> Self {
        .init(
            id: id,
            name: name,
            goals: goals
        )
    }
}

extension LearningGoal {
    static func fixture(
        id: String = "Dummy",
        name: String = "Logic and Programming",
        progress: Double = 0.1) -> Self {
        .init(
            id: id,
            name: name,
            progress: progress
        )
    }
}

extension LearningObjective {
    static func fixture(
        id: String = "TMD300",
        isCore: Bool = false,
        Description: String = "I can describe the features and benefits of the subscription model and know when it is appropriate to use it.",
        isLearned: Bool = false
    ) -> Self {
        .init(
            id: id,
            isCore: isCore,
            Description: Description,
            isLearned: isLearned)
    }
}

#endif
