import SwiftUI

public typealias UnknownErrorCallback = () -> Void
public typealias SignOutCallback = () -> Void

struct UnknownErrorView: View {
    
    let action: UnknownErrorCallback
    
    var body: some View {
        VStack{
            Spacer()

            Assets.errorImage.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(80)
            
            Text("Oops!")
                .font(.largeTitle)
                .bold()
            Text("An error's occured")
                .font(.title)
            Spacer()
            Button(action: action,
                   label: {
                    ZStack{
                        Color(.systemBlue)
                        Text("Try Again")
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .cornerRadius(10)
                   })
            
        }
        .padding(30)
    }
}

#if DEBUG
struct UnknownErrorView_Preview: PreviewProvider {
    static var previews: some View {
        UnknownErrorView(action: {})
    }
}
#endif
