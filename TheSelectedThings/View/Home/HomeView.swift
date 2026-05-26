//
//  HomeView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject var homeVM = HomeViewModel.shared
    
    // Adaptive 2-column grid layout for premium lookbook cards
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            // High-end minimalist light background
            Color(hex: "FCFCFC")
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // 1. Premium Lookbook Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SELECTED THINGS")
                            .font(.customfont(.bold, fontSize: 13))
                            .foregroundColor(.secondaryText)
                            .tracking(2.5)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("The Lookbook")
                                .font(.customfont(.bold, fontSize: 32))
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                            
                            // Visual indication of current guest status
                            Text("GUEST MODE")
                                .font(.customfont(.bold, fontSize: 9))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.primaryText.opacity(0.85))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, .topInsets + 15)
                    .padding(.bottom, 15)
                    
                    // 2. Modern Minimalist Search Bar
                    SearchTextField(placholder: "Search design, brand, or designer...", txt: $homeVM.txtSearch)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    // 3. Featured Hero: Design of the Day (Only visible if search is empty)
                    if homeVM.txtSearch.isEmpty && homeVM.selectedCategory == "All" {
                        if let heroProduct = ProductModel.curatedProducts.first {
                            NavigationLink {
                                ProductDetailView(detailVM: ProductDetailViewModel(prodObj: heroProduct))
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .bottomLeading) {
                                        // Hero image with warm architectural overlay
                                        WebImage(url: URL(string: heroProduct.image))
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.6))
                                            .scaledToFill()
                                            .frame(height: 240)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .clipped()
                                        
                                        LinearGradient(
                                            colors: [.clear, .black.opacity(0.4)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                        
                                        // Floating premium tags
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("DESIGN OF THE DAY")
                                                .font(.customfont(.bold, fontSize: 10))
                                                .foregroundColor(.white)
                                                .tracking(2.0)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color.black.opacity(0.75))
                                                .cornerRadius(6)
                                            
                                            Text(heroProduct.name)
                                                .font(.customfont(.bold, fontSize: 24))
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        }
                                        .padding(20)
                                    }
                                    .frame(height: 240)
                                    
                                    // Hero details
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(heroProduct.brandName.uppercased())
                                                .font(.customfont(.bold, fontSize: 11))
                                                .foregroundColor(.secondaryText)
                                                .tracking(1.0)
                                            
                                            Text("By \(heroProduct.designer)")
                                                .font(.customfont(.medium, fontSize: 13))
                                                .foregroundColor(.primaryText)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 4) {
                                            Text("View Piece")
                                                .font(.customfont(.bold, fontSize: 13))
                                                .foregroundColor(.primaryText)
                                            Image(systemName: "arrow.right")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.primaryText)
                                        }
                                    }
                                    .padding(16)
                                    .background(Color.white)
                                }
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                                )
                                .padding(.horizontal, 20)
                                .padding(.bottom, 25)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // 4. Categorized Filtering Tabs
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Browse Collections")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.primaryText)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                // "All" tab
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        homeVM.selectedCategory = "All"
                                    }
                                } label: {
                                    Text("All")
                                        .font(.customfont(.semibold, fontSize: 14))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(homeVM.selectedCategory == "All" ? Color.primaryText : Color.black.opacity(0.03))
                                        .foregroundColor(homeVM.selectedCategory == "All" ? .white : .primaryText)
                                        .cornerRadius(20)
                                }
                                
                                ForEach(homeVM.typeArr, id: \.id) { type in
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            homeVM.selectedCategory = type.name
                                        }
                                    } label: {
                                        Text(type.name)
                                            .font(.customfont(.semibold, fontSize: 14))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(homeVM.selectedCategory == type.name ? Color.primaryText : Color.black.opacity(0.03))
                                            .foregroundColor(homeVM.selectedCategory == type.name ? .white : .primaryText)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // 5. Lookbook Grid Feed
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(homeVM.selectedCategory == "All" ? "Selected Masterpieces" : "\(homeVM.selectedCategory) Collection")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                            
                            Text("\(homeVM.filteredListArr.count) items")
                                .font(.customfont(.semibold, fontSize: 12))
                                .foregroundColor(.secondaryText)
                        }
                        .padding(.horizontal, 20)
                        
                        if homeVM.filteredListArr.isEmpty {
                            // Empty results
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondaryText.opacity(0.5))
                                    .padding(.top, 40)
                                
                                Text("No design items found")
                                    .font(.customfont(.bold, fontSize: 16))
                                    .foregroundColor(.primaryText)
                                
                                Text("Try searching for another style, brand, or designer.")
                                    .font(.customfont(.regular, fontSize: 14))
                                    .foregroundColor(.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(homeVM.filteredListArr, id: \.id) { product in
                                    ProductCell(pObj: product)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, .bottomInsets + 90)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $homeVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(homeVM.errorMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
