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
    var width: Double = 180.0
    
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink {
            ProductDetailView(detailVM: ProductDetailViewModel(prodObj: pObj))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                // Image container with glassmorphic backing
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.03))
                    
                    WebImage(url: URL(string: pObj.image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.4))
                        .scaledToFit()
                        .frame(width: width - 30, height: 110)
                        .padding(10)
                }
                .frame(width: width - 20, height: 130)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Brand Name in small uppercase
                    Text(pObj.brandName.uppercased())
                        .font(.customfont(.bold, fontSize: 10))
                        .foregroundColor(.secondaryText)
                        .tracking(1.0)
                        .lineLimit(1)
                    
                    // Product Name
                    Text(pObj.name)
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                    
                    // Designer Name
                    if !pObj.designer.isEmpty {
                        Text("by \(pObj.designer)")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.secondaryText)
                            .lineLimit(1)
                    }
                    
                    Spacer(minLength: 0)
                    
                    // Elegant Price
                    Text("$\(pObj.price, specifier: "%.2f")")
                        .font(.customfont(.semibold, fontSize: 15))
                        .foregroundColor(.primaryText)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 6)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .frame(width: width, height: 230)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(0.10))
            )
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.12), radius: 15, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(
                        LinearGradient(
                            colors: [Color.green.opacity(0.60), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2.29
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(ProductCellButtonStyle(isPressed: $isPressed))
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
