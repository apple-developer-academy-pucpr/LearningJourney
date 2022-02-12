import SwiftUI

struct LearningStatusButtonStyle: ButtonStyle {
    let status: LearningObjectiveStatus
    let isBookmarked: Bool
    func makeBody(configuration: Configuration) -> some View {
        Group {
            switch status {
            case .untutored where isBookmarked:
                configuration.label
                    .background(.orange)
            case .untutored:
                configuration.label
                    .foregroundColor(.white)
                    .background(Color(hex: "#BBBBCD"))
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
        .foregroundColor(.white)
        .cornerRadius(5)
    }
}
