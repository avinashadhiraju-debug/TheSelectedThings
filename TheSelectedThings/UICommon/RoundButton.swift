//
//  RoundButton.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct GlassButtonStyle: ButtonStyle {
    @State private var isHovered = false
    var isAdaptive: Bool = true
    var useStyle2: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    private var isLightMode: Bool {
        isAdaptive && colorScheme == .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isLightMode ? .primaryText : .white)
            .background(
                Capsule()
                    .fill(isLightMode ? Color.black.opacity(0.06) : Color.white.opacity(0.10))
            )
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: useStyle2 ? [Color.clear, Color.primaryApp.opacity(0.60), Color.clear] : [Color.primaryApp.opacity(0.60), Color.clear, Color.secondaryprimaryApp.opacity(0.60)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: useStyle2 ? 3.0 : 2.29
                    )
            )
            .shadow(color: Color.black.opacity(isLightMode ? 0.03 : 0.15), radius: 20, x: 0, y: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : (isHovered ? 1.02 : 1.0))
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

struct RoundButton: View {
    var title: String = "Tap Me"
    var image: String? = nil
    var isAdaptive: Bool = true
    var useStyle2: Bool = false
    var renderingMode: Image.TemplateRenderingMode = .template
    var didTap: (() -> ())?
    
    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            didTap?()
        } label: {
            HStack(spacing: 12) {
                if let imageName = image {
                    if UIImage(named: imageName) != nil {
                        Image(imageName)
                            .renderingMode(renderingMode)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                
                Text(title)
                    .font(.customfont(.semibold, fontSize: 15))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        }
        .buttonStyle(GlassButtonStyle(isAdaptive: isAdaptive, useStyle2: useStyle2)) // Applies the custom liquid glass material style directly
    }
}

#Preview {
    ZStack {
        Color.black // Dark background to match Figma canvas
            .ignoresSafeArea()
        
        RoundButton(title: "Get Started") {
            print("Button tapped")
        }
        .padding()
    }
}

