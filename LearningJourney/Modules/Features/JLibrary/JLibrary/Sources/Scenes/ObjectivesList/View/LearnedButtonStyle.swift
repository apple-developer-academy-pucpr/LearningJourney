import SwiftUI

struct LearningStatusButtonStyle: ButtonStyle {
    let status: LearningObjectiveStatus
    func makeBody(configuration: Configuration) -> some View {
        switch status {
        case .untutored:
            configuration.label
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.white)
                .cornerRadius(5)
        case .learning:
            configuration.label
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.yellow)
                .cornerRadius(5)
        case .learned:
            configuration.label
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.blue)
                .cornerRadius(5)
        case .mastered:
            configuration.label
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.red)
                .cornerRadius(5)
        }
    }
}
