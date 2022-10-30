import UI
import SwiftUI

struct FeatureRow: View {
    
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack{
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55)
                .foregroundColor(Color(UI.Assets.iconColor.name))
                .padding(.trailing, 15)
            VStack(alignment: .leading){
                
                Text(title)
                    .bold()
                Text(description)
            }
           
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FeatureRow(icon: "checkmark.circle", title: "Track your progress", description: "See what you've already learned.")
    }
}
