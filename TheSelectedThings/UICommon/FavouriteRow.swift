//
//  FavouriteRow.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteRow: View {
    @State var fObj: ProductModel = ProductModel(dict: [:])
    
    var body: some View {
        NavigationLink {
            ProductDetailView(detailVM: ProductDetailViewModel(prodObj: fObj))
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    // Glassmorphic small image backing
                    ZStack {
                        Color.black.opacity(0.02)
                            .cornerRadius(10)
                        
                        WebImage(url: URL(string: fObj.image))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.4))
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(4)
                    }
                    .frame(width: 58, height: 58)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(fObj.brandName.uppercased())
                            .font(.customfont(.bold, fontSize: 10))
                            .foregroundColor(.secondaryText)
                            .tracking(1.0)
                        
                        Text(fObj.name)
                            .font(.customfont(.bold, fontSize: 16))
                            .foregroundColor(.primaryText)
                            .lineLimit(1)
                        
                        if !fObj.designer.isEmpty {
                            Text("by \(fObj.designer)")
                                .font(.customfont(.medium, fontSize: 12))
                                .foregroundColor(.secondaryText)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    Text("$\(fObj.price, specifier: "%.2f")")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.primaryText)
                    
                    Image("next")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.secondaryText)
                }
                .padding(.vertical, 12)
                
                Divider()
            }
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FavouriteRow_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteRow(fObj: ProductModel.curatedProducts[0])
    }
}
