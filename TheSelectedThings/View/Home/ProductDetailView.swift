//
//  ProductDetailView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var detailVM: ProductDetailViewModel = ProductDetailViewModel(prodObj: ProductModel(dict: [:]))
    
    var body: some View {
        ZStack {
            // Main Background Color to match modern light themes
            Color.white
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // 1. Curved Gradient Image Header
                    ZStack(alignment: .bottomLeading) {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.04), Color.black.opacity(0.01), Color.white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: .screenWidth, height: .screenWidth * 0.9)
                        .cornerRadius(32, corner: [.bottomLeft, .bottomRight])
                        .shadow(color: Color.black.opacity(0.01), radius: 10, x: 0, y: 8)
                        
                        // Image Carousel (using TabView) or single WebImage
                        Group {
                            if !detailVM.imageArr.isEmpty {
                                TabView {
                                    ForEach(detailVM.imageArr, id: \.id) { imgObj in
                                        WebImage(url: URL(string: imgObj.image))
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.5))
                                            .scaledToFit()
                                            .frame(width: .screenWidth * 0.8, height: .screenWidth * 0.8)
                                    }
                                }
                                .tabViewStyle(.page)
                                .indexViewStyle(.page(backgroundDisplayMode: .always))
                            } else {
                                WebImage(url: URL(string: detailVM.pObj.image))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFit()
                                    .frame(width: .screenWidth * 0.8, height: .screenWidth * 0.8)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                        .frame(width: .screenWidth, height: .screenWidth * 0.8)
                        .padding(.bottom, 20)
                        
                        // Floating Category / Brand Badge
                        if !detailVM.pObj.catName.isEmpty {
                            Text(detailVM.pObj.catName.uppercased())
                                .font(.customfont(.bold, fontSize: 10))
                                .foregroundColor(.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(20)
                                .padding(.leading, 20)
                                .padding(.bottom, 15)
                        }
                    }
                    .frame(width: .screenWidth, height: .screenWidth * 0.9)
                    
                    // 2. Product Title, Designer & Favorite
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(detailVM.pObj.brandName.uppercased())
                                    .font(.customfont(.bold, fontSize: 12))
                                    .foregroundColor(.secondaryText)
                                    .tracking(2.0)
                                
                                Text(detailVM.pObj.name)
                                    .font(.customfont(.bold, fontSize: 26))
                                    .foregroundColor(.primaryText)
                                    .lineLimit(2)
                                
                                if !detailVM.pObj.designer.isEmpty {
                                    Text("Designed by \(detailVM.pObj.designer)")
                                        .font(.customfont(.medium, fontSize: 16))
                                        .foregroundColor(.secondaryText)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                // Dynamic Haptic Feedback
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    detailVM.serviceCallAddRemoveFav()
                                }
                            } label: {
                                Image(detailVM.isFav ? "favorite" : "fav")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 26, height: 26)
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(detailVM.isFav ? Color.primaryText.opacity(0.08) : Color.black.opacity(0.03))
                                    )
                            }
                        }
                        
                        // Star Rating & Review count
                        HStack(spacing: 6) {
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= detailVM.pObj.avgRating ? "star.fill" : "star")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(index <= detailVM.pObj.avgRating ? .black : Color.placeholder.opacity(0.5))
                                        .frame(width: 14, height: 14)
                                }
                            }
                            
                            Text(String(format: "%.1f", Double(detailVM.pObj.avgRating)))
                                .font(.customfont(.bold, fontSize: 13))
                                .foregroundColor(.primaryText)
                            
                            Text("(\(detailVM.pObj.reviews.isEmpty ? 2 : detailVM.pObj.reviews.count) reviews)")
                                .font(.customfont(.medium, fontSize: 12))
                                .foregroundColor(.secondaryText)
                        }
                        .padding(.top, 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    
                    // Price Row
                    HStack {
                        Text("Est. Valuation")
                            .font(.customfont(.medium, fontSize: 15))
                            .foregroundColor(.secondaryText)
                        Spacer()
                        Text("$\(detailVM.pObj.price, specifier: "%.2f")")
                            .font(.customfont(.bold, fontSize: 28))
                            .foregroundColor(.primaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    
                    // 3. Design Magazine Description & Specs Card Grid
                    VStack(spacing: 12) {
                        
                        // Rich Description Card
                        VStack(alignment: .leading, spacing: 0) {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    detailVM.showDetail()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "text.alignleft")
                                        .foregroundColor(.primaryText)
                                        .font(.system(size: 16, weight: .semibold))
                                        .frame(width: 24)
                                    
                                    Text("The Design Story")
                                        .font(.customfont(.semibold, fontSize: 16))
                                        .foregroundColor(.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.secondaryText)
                                        .rotationEffect(.degrees(detailVM.isShowDetail ? 90 : 0))
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 16)
                            }
                            
                            if detailVM.isShowDetail {
                                Text(detailVM.pObj.detail)
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(.secondaryText)
                                    .lineSpacing(6)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        
                        // Collapsible Product Specifications Card
                        VStack(alignment: .leading, spacing: 0) {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    detailVM.showNutrition()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .foregroundColor(.primaryText)
                                        .font(.system(size: 16))
                                        .frame(width: 24)
                                    
                                    Text("Design Specifications")
                                        .font(.customfont(.semibold, fontSize: 16))
                                        .foregroundColor(.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.secondaryText)
                                        .rotationEffect(.degrees(detailVM.isShowNutrition ? 90 : 0))
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 16)
                            }
                            
                            if detailVM.isShowNutrition {
                                VStack(spacing: 12) {
                                    let specs = detailVM.pObj.specifications.isEmpty ? [
                                        "Materials": "Premium high-grade compound",
                                        "Designer": detailVM.pObj.designer.isEmpty ? "Curated designer" : detailVM.pObj.designer,
                                        "Aesthetic": "Modernist, Minimalist"
                                    ] : detailVM.pObj.specifications
                                    
                                    ForEach(specs.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                        HStack {
                                            Text(key)
                                                .font(.customfont(.semibold, fontSize: 14))
                                                .foregroundColor(.secondaryText)
                                            Spacer()
                                            Text(value)
                                                .font(.customfont(.semibold, fontSize: 14))
                                                .foregroundColor(.primaryText)
                                        }
                                        if key != specs.sorted(by: { $0.key < $1.key }).last?.key {
                                            Divider()
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        
                        // 4. Community Reviews & Ratings Section (Expanded & Embedded beautifully)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "star.bubble.fill")
                                    .foregroundColor(.primaryText)
                                    .font(.system(size: 16))
                                    .frame(width: 24)
                                
                                Text("Community Reviews")
                                    .font(.customfont(.bold, fontSize: 16))
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                            
                            Divider()
                                .padding(.horizontal, 16)
                            
                            let reviews = detailVM.pObj.reviews.isEmpty ? [
                                ReviewModel(userName: "Jane K.", rating: 5, date: "May 25, 2026", comment: "Breathtaking design and stellar build quality. A true work of art!"),
                                ReviewModel(userName: "Oliver S.", rating: 5, date: "May 19, 2026", comment: "Extremely minimal aesthetic. A perfect showcase of form meeting function.")
                            ] : detailVM.pObj.reviews
                            
                            ForEach(reviews) { review in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        // Profile picture initials bubble
                                        Text(String(review.userName.prefix(2)).uppercased())
                                            .font(.customfont(.bold, fontSize: 11))
                                            .foregroundColor(.white)
                                            .frame(width: 28, height: 28)
                                            .background(Circle().fill(Color.black.opacity(0.85)))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(review.userName)
                                                .font(.customfont(.bold, fontSize: 13))
                                                .foregroundColor(.primaryText)
                                            Text(review.date)
                                                .font(.customfont(.medium, fontSize: 10))
                                                .foregroundColor(.secondaryText)
                                        }
                                        
                                        Spacer()
                                        
                                        // User star rating
                                        HStack(spacing: 2) {
                                            ForEach(1...5, id: \.self) { idx in
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(idx <= review.rating ? .black : Color.placeholder.opacity(0.3))
                                                    .frame(width: 10, height: 10)
                                            }
                                        }
                                    }
                                    
                                    Text(review.comment)
                                        .font(.customfont(.medium, fontSize: 13))
                                        .foregroundColor(.secondaryText)
                                        .lineSpacing(4)
                                        .padding(.leading, 36)
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
                                
                                if review != reviews.last {
                                    Divider()
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 4)
                                }
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    // 5. Sleek "View Store" Call To Action Button (Safari Safe Link)
                    if let storeUrl = URL(string: detailVM.pObj.externalURL.isEmpty ? "https://www.apple.com" : detailVM.pObj.externalURL) {
                        Link(destination: storeUrl) {
                            HStack(spacing: 12) {
                                Image(systemName: "safari.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("View Official Store")
                                    .font(.customfont(.bold, fontSize: 16))
                            }
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                            .background(Color.primaryText)
                            .cornerRadius(18)
                            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 15)
                        .padding(.bottom, .bottomInsets + 35)
                        .simultaneousGesture(TapGesture().onEnded {
                            // Haptic Trigger
                            let generator = UIImpactFeedbackGenerator(style: .heavy)
                            generator.impactOccurred()
                        })
                    }
                }
            }
            
            // Glassmorphic Circular Back & Share Floating Headers
            VStack {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(12)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    Button {
                        // Share Lookbook Action
                        if let storeUrl = URL(string: detailVM.pObj.externalURL) {
                            let av = UIActivityViewController(activityItems: ["Check out this gorgeous curated piece: \(detailVM.pObj.name) by \(detailVM.pObj.designer)", storeUrl], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = windowScene.windows.first?.rootViewController {
                                rootVC.present(av, animated: true, completion: nil)
                            }
                        }
                    } label: {
                        Image("share")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(12)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }
                
                Spacer()
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $detailVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(detailVM.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear {
            // Expand by default for lookbook
            detailVM.isShowDetail = true
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(detailVM: ProductDetailViewModel(prodObj: ProductModel.curatedProducts[0]))
    }
}
