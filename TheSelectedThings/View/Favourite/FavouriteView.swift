//
//  FavouriteView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteView: View {
    @StateObject var favVM = FavouriteViewModel.shared
    
    var body: some View {
        ZStack {
            // Minimal background
            Color.bgDetail
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Premium Screen Header
                HStack {
                    Spacer()
                    Text("Wishlist")
                        .font(.customfont(.bold, fontSize: 18))
                        .foregroundColor(.primaryText)
                        .tracking(1.0)
                        .frame(height: 46)
                    Spacer()
                }
                .padding(.top, .topInsets)
                .background(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.02), radius: 3, x: 0, y: 2)
                
                // 2. Main Content
                if favVM.listArr.isEmpty {
                    // Elevated Whimsical Empty State
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "heart.text.square")
                            .font(.system(size: 64))
                            .foregroundColor(.secondaryText.opacity(0.35))
                        
                        Text("Your collection is empty")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.primaryText)
                        
                        Text("Browse discover feed and save extraordinary designs to curate your personal lookbook.")
                            .font(.customfont(.regular, fontSize: 14))
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(favVM.listArr, id: \.id) { fObj in
                                FavouriteRow(fObj: fObj)
                            }
                        }
                        .padding(20)
                        .padding(.bottom, .bottomInsets + 90)
                    }
                }
            }
        }
        .onAppear {
            favVM.serviceCallList()
        }
        .ignoresSafeArea()
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
