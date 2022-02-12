import SwiftUI

struct LearningStatusButtonStyle: ButtonStyle {
    let status: LearningObjectiveStatus
    func makeBody(configuration: Configuration) -> some View {
        Group {
            switch status {
            case .untutored:
                configuration.label
                    .foregroundColor(.white)
                    .background(Color(hex: "#BBBBCD"))
            case.eagerToLearn:
                configuration.label
            case .learning:
                configuration.label
                    .foregroundColor(.white)
                    .background(.blue)
            case .learned:
                configuration.label
                    .foregroundColor(.white)
                    .background(.pink)
            case .mastered:
                configuration.label
                    .foregroundColor(.white)
                    .background(.purple)
            }
        }
        .cornerRadius(5)
    }
}
