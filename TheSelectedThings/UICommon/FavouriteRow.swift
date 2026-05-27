//
//  FavouriteRow.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteRow: View {
    @State var fObj: ProductModel = ProductModel(dict: [:])
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink {
            ProductDetailView(detailVM: ProductDetailViewModel(prodObj: fObj))
        } label: {
            HStack(spacing: 16) {
                // 1. Sleek Glassmorphic Floating Image Container
                ZStack {
                    // Subtle background gradient for depth and premium feel
                    LinearGradient(
                        colors: colorScheme == .dark ?
                            [Color.black.opacity(0.40), Color.black.opacity(0.15)] :
                            [Color.white.opacity(0.80), Color.white.opacity(0.20)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    WebImage(url: URL(string: fObj.image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.4))
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(14)
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color.primaryApp.opacity(0.35), Color.clear, Color.secondaryprimaryApp.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.2
                        )
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.04), radius: 6, x: 0, y: 3)
                
                // 2. High-End Curated Typography & Content Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(fObj.brandName.uppercased())
                        .font(.customfont(.bold, fontSize: 9.5))
                        .foregroundColor(.secondaryText)
                        .tracking(2.0)
                        .lineLimit(1)
                    
                    Text(fObj.name)
                        .font(.customfont(.bold, fontSize: 16))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                    
                    // Curated Details: Rating Stars + Designer
                    HStack(spacing: 6) {
                        HStack(spacing: 1.5) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < fObj.avgRating ? "star.fill" : "star")
                                    .font(.system(size: 8.5, weight: .bold))
                                    .foregroundColor(index < fObj.avgRating ? Color(hex: "F5A623") : Color.placeholder.opacity(0.4))
                            }
                        }
                        
                        Text("•")
                            .font(.system(size: 9))
                            .foregroundColor(.secondaryText.opacity(0.4))
                        
                        Text(fObj.designer.isEmpty ? "Curated" : fObj.designer)
                            .font(.customfont(.medium, fontSize: 11.5))
                            .foregroundColor(.secondaryText)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // 3. Price & Interactive Glassmorphic Heart Button
                VStack(alignment: .trailing, spacing: 8) {
                    Text("$\(fObj.price, specifier: "%.2f")")
                        .font(.customfont(.bold, fontSize: 16))
                        .foregroundColor(.primaryText)
                    
                    // Interactive Glassmorphic Heart Button with tactile haptics
                    Button {
                        // Gentle haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                        
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            FavouriteViewModel.shared.toggleFavorite(product: fObj)
                            FavouriteViewModel.shared.serviceCallAddRemoveFav(productId: fObj.id)
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: colorScheme == .dark ?
                                            [Color.white.opacity(0.12), Color.white.opacity(0.02)] :
                                            [Color.white.opacity(0.90), Color.white.opacity(0.40)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.primaryApp.opacity(0.35),
                                                    Color.clear,
                                                    Color.secondaryprimaryApp.opacity(0.20)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.0
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1.5)
                            
                            Image("favorate")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(Color(hex: "FF3B30"))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: colorScheme == .dark ?
                                [Color.cardBackground.opacity(0.28), Color.cardBackground.opacity(0.08)] :
                                [Color.cardBackground.opacity(0.75), Color.cardBackground.opacity(0.45)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(colorScheme == .dark ? 0.15 : 0.8),
                                Color.clear,
                                Color.red.opacity(colorScheme == .dark ? 0.20 : 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.15 : 0.03), radius: 15, x: 0, y: 8)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(FavouriteRowButtonStyle(isPressed: $isPressed))
        .padding(.vertical, 6)
    }
}

struct FavouriteRowButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, pressed in
                isPressed = pressed
            }
    }
}

struct FavouriteRow_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteRow(fObj: ProductModel.curatedProducts[0])
            .padding()
    }
}
