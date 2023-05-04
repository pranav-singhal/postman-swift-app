
import SwiftUI

struct CircleGroupView: View {
    
    @State var ShapeColor: Color
    @State var ShapeOpacity: Double
    @State private var isAnimating: Bool = false;
    @State var frameDim: CGFloat;
    @State var lineWidth: CGFloat;

    var body: some View {
        ZStack {
            Circle()
                .stroke(ShapeColor.opacity(ShapeOpacity), lineWidth: lineWidth)
                .frame(width: frameDim, height: frameDim, alignment: .center)
            Circle()
                
                .stroke(ShapeColor.opacity(ShapeOpacity), lineWidth: lineWidth * 2)
                
                .frame(width: frameDim, height: frameDim, alignment: .center)
                .foregroundColor(.gray)

        } // :Zstack
        .blur(radius: isAnimating ? 0 : 10)
        .opacity(isAnimating ? 1: 0)
        .scaleEffect(isAnimating ? 1 : 0.5)
        .animation(.easeOut(duration: 1), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct CircleGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CircleGroupView(ShapeColor: .accentColor, ShapeOpacity: 0.2, frameDim: CGFloat(280), lineWidth: CGFloat(40))
    }
}
