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
                    .cornerRadius(5)
            case .learning:
                configuration.label
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(5)
            case .learned:
                configuration.label
                    .foregroundColor(.white)
                    .background(.pink)
                    .cornerRadius(5)
            case .mastered:
                configuration.label
                    .foregroundColor(.white)
                    .background(.purple)
                    .cornerRadius(5)
            }
        }
    }
}
