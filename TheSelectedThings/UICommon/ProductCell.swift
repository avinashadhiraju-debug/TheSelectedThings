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
    
    var body: some View {
        NavigationLink {
            ProductDetailView(detailVM: ProductDetailViewModel(prodObj: pObj))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                // Image container with glassmorphic backing
                ZStack {
                    Color.black.opacity(0.02)
                        .cornerRadius(12)
                    
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
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(pObj: ProductModel.curatedProducts[0])
    }
}
