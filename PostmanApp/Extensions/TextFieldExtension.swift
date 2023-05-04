import SwiftUI

struct BottomBorderInputField: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 10)
            .overlay(VStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
            }, alignment: .bottom)
            .padding(.trailing, 10)
        
            .buttonBorderShape(.capsule)
    }
}


extension TextField {
    func bottomBorderStyle() -> some View {
        modifier(BottomBorderInputField())
    }
}
