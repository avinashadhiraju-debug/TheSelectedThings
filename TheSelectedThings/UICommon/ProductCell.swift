//
//  ProductCell.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCell: View {
    var pObj: ProductModel = ProductModel(dict: [:])
    var width: CGFloat? = nil  // nil fills the grid column; pass a value for fixed-width horizontal scroll use

    @State private var isPressed = false

    var body: some View {
        NavigationLink {
            ProductDetailView(detailVM: ProductDetailViewModel(prodObj: pObj))
        } label: {
            cellContent
        }
        .buttonStyle(ProductCellButtonStyle(isPressed: $isPressed))
    }

    private static let cardGradient = LinearGradient(
        colors: [Color.primaryApp.opacity(0.50), Color.white],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    private var imageContainer: some View {
        Color.clear
            .aspectRatio(3/4, contentMode: .fit)
            .overlay {
                WebImage(url: URL(string: pObj.image))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.4))
                    .scaledToFill()
                    .clipped()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var cellContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            imageContainer

            VStack(alignment: .leading, spacing: 4) {
                Text(pObj.brandName.uppercased())
                    .font(.customfont(.bold, fontSize: 10))
                    .foregroundColor(.secondaryText)
                    .tracking(1.5)
                    .lineLimit(1)

                Text(pObj.name)
                    .font(.customfont(.bold, fontSize: 15))
                    .foregroundColor(.primaryText)
                    .lineLimit(1)

                Text(pObj.designer.isEmpty ? "Curated Design" : "by \(pObj.designer)")
                    .font(.customfont(.medium, fontSize: 12))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)

                Text("$\(pObj.price, specifier: "%.2f")")
                    .font(.customfont(.semibold, fontSize: 15))
                    .foregroundColor(.primaryText)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .frame(minWidth: width ?? 0, maxWidth: width ?? .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Self.cardGradient, lineWidth: 3)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 20, x: 0, y: 10)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

// Custom button style to propagate the touch/pressed state smoothly for scale animations
struct ProductCellButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, pressed in
                isPressed = pressed
            }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            ProductCell(pObj: ProductModel.curatedProducts[0])
        }
    }
}
