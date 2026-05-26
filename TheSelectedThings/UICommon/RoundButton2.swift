import SwiftUI

struct GlassButtonStyle2: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.10))
            )
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.60), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2.29
                    )
            )
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : (isHovered ? 1.02 : 1.0))
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

struct RoundButton2: View {
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
        .buttonStyle(GlassButtonStyle2()) // Applies the custom liquid glass material style directly
    }
}

#Preview {
    ZStack {
        Color.black // Dark background to match Figma canvas
            .ignoresSafeArea()
        
        RoundButton2(title: "Get Started") {
            print("Button tapped")
        }
        .padding()
    }
}
