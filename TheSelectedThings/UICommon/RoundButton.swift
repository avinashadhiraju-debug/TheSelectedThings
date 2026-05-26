import SwiftUI

struct RoundButton: View {
    var title: String = "Tap Me"
    var image: String? = nil
    var didTap: (() -> ())?
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            didTap?()
        } label: {
            HStack(spacing: 12) {
                if let imageName = image {
                    Image(imageName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(title)
                    .font(.customfont(.semibold, fontSize: 18))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        }
        .buttonStyle(.glass) // Applies the liquid glass material
    }
}

#Preview {
    ZStack {
        RoundButton(title: "Get Started") {
            print("Button tapped")
        }
        .padding()
    }
}
