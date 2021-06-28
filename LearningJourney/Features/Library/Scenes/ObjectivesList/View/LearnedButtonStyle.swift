import SwiftUI

struct LearnedButtonStyle: ButtonStyle {
    
    let isHightlighted: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isHightlighted {
                configuration.label
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.blue)
                    .cornerRadius(5)
            } else {
                configuration.label
                    .foregroundColor(.blue)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .font(.system(size: 14))
    }
}
