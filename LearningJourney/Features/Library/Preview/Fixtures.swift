#if DEBUG
extension LearningStrand {
    static func fixture(
        name: String = "Logic and Programming",
        goals: [LearningGoal] = []
    ) -> Self {
        .init(
            name: name,
            goals: goals
        )
    }
}

extension LearningGoal {
    static func fixture(
        name: String = "Logic and Programming",
        progress: Double = 0.1) -> Self {
        .init(
            name: name,
            progress: progress
        )
    }
}

#endif
