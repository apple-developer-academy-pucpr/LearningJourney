#if DEBUG
extension LearningStrand {
    static func fixture(
        id: Int = 1,
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
        id: Int = .init(),
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
        id: Int = 0,
        code: String = "TMD300",
        type: LearningObjectiveType = .core,
        description: String = "I can describe the features and benefits of the subscription model and know when it is appropriate to use it.",
        status: LearningObjectiveStatus = .untutored
    ) -> Self {
        .init(
            id: id,
            code: code,
            description: description,
            type: type,
            status: status)
    }
}

#endif
