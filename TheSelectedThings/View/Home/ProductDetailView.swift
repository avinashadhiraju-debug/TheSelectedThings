//
//  ProductDetailView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    @StateObject var detailVM: ProductDetailViewModel = ProductDetailViewModel(prodObj: ProductModel(dict: [:]))
    
    var body: some View {
        ZStack {
            // Main Background Color to match modern light themes
            Color.bgDetail
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    ZStack(alignment: .bottomLeading) {
                        imageCarousel

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
                    .frame(width: .screenWidth, height: .screenWidth * 4 / 3)
                    
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
                                Image("favorate")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(detailVM.isFav ? .red : .primaryApp.opacity(0.9))
                                    .frame(width: 24, height: 24)
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(detailVM.isFav ? Color.red.opacity(0.12) : Color.black.opacity(0.03))
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
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.cardBackground))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primaryApp.opacity(0.2), lineWidth: 2)
                        )
                        
                        let cleanName = detailVM.pObj.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let cleanBrand = detailVM.pObj.brandName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            if let storeUrl = URL(string: detailVM.pObj.externalURL.isEmpty ? "https://www.apple.com" : detailVM.pObj.externalURL) {
                                RoundButton(title: "Official Store", image: "safari") {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    UIApplication.shared.open(storeUrl)
                                }
                            }
                            
                            if let momaUrl = URL(string: "https://store.moma.org/search?q=\(cleanName)") {
                                RoundButton(title: "Amazon", image: "amazon_logo") {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    UIApplication.shared.open(momaUrl)
                                }
                            }
                            
                            if let archiproductsUrl = URL(string: "https://www.archiproducts.com/en/search?q=\(cleanBrand)%20\(cleanName)") {
                                RoundButton(title: "Ebay", image: "ebay_logo") {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    UIApplication.shared.open(archiproductsUrl)
                                }
                            }
                            
                            if let dwrUrl = URL(string: "https://www.dwr.com/search?q=\(cleanName)") {
                                RoundButton(title: "BestBuy", image: "BestBuy_logo") {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    UIApplication.shared.open(dwrUrl)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                        
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
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.cardBackground))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primaryApp.opacity(0.2), lineWidth: 2)
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
                                
                                NavigationLink {
                                    WriteReviewView { newReview in
                                        var currentReviews = detailVM.pObj.reviews
                                        if currentReviews.isEmpty {
                                            currentReviews = [
                                                ReviewModel(userName: "Jane K.", rating: 5, date: "May 25, 2026", comment: "Breathtaking design and stellar build quality. A true work of art!"),
                                                ReviewModel(userName: "Oliver S.", rating: 5, date: "May 19, 2026", comment: "Extremely minimal aesthetic. A perfect showcase of form meeting function.")
                                            ]
                                        }
                                        currentReviews.append(newReview)
                                        detailVM.pObj.reviews = currentReviews
                                        
                                        // Recalculate average rating
                                        let totalRating = currentReviews.map { $0.rating }.reduce(0, +)
                                        detailVM.pObj.avgRating = Int(round(Double(totalRating) / Double(currentReviews.count)))
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "square.and.pencil")
                                            .font(.system(size: 13, weight: .bold))
                                        Text("Write Review")
                                            .font(.customfont(.bold, fontSize: 12))
                                    }
                                    .foregroundColor(.primaryApp)
                                }
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
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.cardBackground))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primaryText.opacity(0.2), lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    // 5. "More Like This" Section (Related products in the same category)
                    let moreLikeThisProducts = ProductModel.curatedProducts.filter { $0.id != detailVM.pObj.id && $0.catName == detailVM.pObj.catName }
                    let displayMoreLikeThis = moreLikeThisProducts.isEmpty ? ProductModel.curatedProducts.filter { $0.id != detailVM.pObj.id } : moreLikeThisProducts
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("More Like This")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.primaryText)
                            .padding(.horizontal, 20)
                        
                        let gridItems = [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ]
                        
                        LazyVGrid(columns: gridItems, spacing: 15) {
                            ForEach(displayMoreLikeThis.prefix(4)) { product in
                                productCell(product: product)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 15)
                    
                    // 6. "Recommendations" Section (Other masterpieces)
                    let recommendedProducts = ProductModel.curatedProducts.filter { $0.id != detailVM.pObj.id && !displayMoreLikeThis.contains($0) }
                    let finalRecs = recommendedProducts.isEmpty ? ProductModel.curatedProducts.filter { $0.id != detailVM.pObj.id } : recommendedProducts
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recommended for You")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.primaryText)
                            .padding(.horizontal, 20)
                        
                        let gridItems = [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ]
                        
                        LazyVGrid(columns: gridItems, spacing: 15) {
                            ForEach(finalRecs.prefix(4)) { product in
                                productCell(product: product)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 15)
                    
                    FooterView()
                        .padding(.bottom, .bottomInsets + 20)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .alert(isPresented: $detailVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(detailVM.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(
                    item: URL(string: detailVM.pObj.externalURL.isEmpty ? "https://www.apple.com" : detailVM.pObj.externalURL) ?? URL(string: "https://www.apple.com")!,
                    subject: Text(detailVM.pObj.name),
                    message: Text("Check out \(detailVM.pObj.name) by \(detailVM.pObj.designer)")
                )
            }
        }
        .onAppear {
            detailVM.isShowDetail = true
        }
    }

    @ViewBuilder
    private var imageCarousel: some View {
        let imageSize: CGFloat = CGFloat.screenWidth
        let imageHeight: CGFloat = imageSize * 4 / 3

        Group {
            if !detailVM.imageArr.isEmpty {
                TabView {
                    ForEach(detailVM.imageArr, id: \.id) { imgObj in
                        let imageURL = URL(string: imgObj.image)
                        WebImage(url: imageURL)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .frame(width: imageSize, height: imageHeight)
                            .clipped()
                    }
                }
                .frame(width: imageSize, height: imageHeight)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            } else {
                let imageURL = URL(string: detailVM.pObj.image)
                WebImage(url: imageURL)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: imageSize, height: imageHeight)
                    .clipped()
            }
        }
        .frame(width: imageSize, height: imageHeight)
    }

    @ViewBuilder
    private func productCell(product: ProductModel, width: CGFloat? = nil) -> some View {
        ProductCell(pObj: product, width: width)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(detailVM: ProductDetailViewModel(prodObj: ProductModel.curatedProducts[0]))
    }
}
