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
    
    // Namespace for premium category sliding capsule transition
    @Namespace private var categoryNamespace
    
    // State to drive hero card pressed animation
    @State private var isHeroPressed = false
    
    // Adaptive 2-column grid layout for lookbook cards
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            // Highly performant, adaptive ambient glow background
            HomeBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // 1. Premium Lookbook Header
                    headerSection
                    
                    // 2. Modern Minimalist Glassmorphic Search Bar
                    searchSection
                    
                    // 3. Featured Hero: Design of the Day (visible only when search is empty)
                    if homeVM.txtSearch.isEmpty && homeVM.selectedCategory == "All" {
                        heroSection
                    }
                    
                    // 4. Categorized Filtering Tabs
                    categoryFilterSection
                    
                    // 5. Lookbook Grid Feed
                    gridSection
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
    
    // MARK: - Subviews
    
    // 1. Header Section
    private var headerSection: some View {
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
                
                // Visual indication of current guest status (glassmorphic badge)
                Text("GUEST MODE")
                    .font(.customfont(.bold, fontSize: 9))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.primaryText.opacity(0.85))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, .topInsets + 15)
        .padding(.bottom, 15)
    }
    
    // 2. Search Section
    private var searchSection: some View {
        ZStack(alignment: .trailing) {
            SearchTextField(placholder: "Search design, brand, or designer...", txt: $homeVM.txtSearch)
            
            if !homeVM.txtSearch.isEmpty {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        homeVM.txtSearch = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondaryText)
                        .padding(.trailing, 30)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // 3. Hero Section (Design of the Day)
    @ViewBuilder
    private var heroSection: some View {
        if let heroProduct = ProductModel.curatedProducts.first {
            NavigationLink {
                ProductDetailView(detailVM: ProductDetailViewModel(prodObj: heroProduct))
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        // Hero image with warm overlay
                        WebImage(url: URL(string: heroProduct.image))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.6))
                            .scaledToFill()
                            .frame(height: 240)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .clipped()
                        
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.45)],
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
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black.opacity(0.75))
                                )
                            
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
                    .background(Color.white.opacity(0.08))
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.08))
                )
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.40), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .scaleEffect(isHeroPressed ? 0.97 : 1.0)
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isHeroPressed)
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
            }
            .buttonStyle(HeroButtonStyle(isPressed: $isHeroPressed))
        }
    }
    
    // 4. Category Filters Section
    private var categoryFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browse Collections")
                .font(.customfont(.bold, fontSize: 18))
                .foregroundColor(.primaryText)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // "All" tab
                    categoryButton(name: "All")
                    
                    ForEach(homeVM.typeArr, id: \.id) { type in
                        categoryButton(name: type.name)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 20)
    }
    
    // Helper to generate premium styled sliding category buttons
    @ViewBuilder
    private func categoryButton(name: String) -> some View {
        let isSelected = homeVM.selectedCategory == name
        
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                homeVM.selectedCategory = name
            }
        } label: {
            Text(name)
                .font(.customfont(.semibold, fontSize: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(isSelected ? .white : .primaryText)
                .background(
                    ZStack {
                        if isSelected {
                            Capsule()
                                .fill(Color.primaryText)
                                .matchedGeometryEffect(id: "activeCategoryCapsule", in: categoryNamespace)
                        } else {
                            Capsule()
                                .fill(Color.black.opacity(0.03))
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // 5. Grid section
    private var gridSection: some View {
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
                emptyStateView
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
    
    // Empty results view
    private var emptyStateView: some View {
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
    }
}

// Button style to propagate press states for hero spring scaling
struct HeroButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { pressed in
                isPressed = pressed
            }
    }
}

// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}

// MARK: - Home Background View

struct HomeBackgroundView: View {
    @State private var moveGradient = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Adaptive off-white base for light mode, deep modern grey/black for dark mode
            if colorScheme == .dark {
                Color(hex: "121212")
            } else {
                Color(hex: "FCFCFC")
            }
            
            // Slow, GPU-friendly animated ambient glow blobs matching primary brand design
            ZStack {
                RadialGradient(colors: [Color.primaryApp.opacity(colorScheme == .dark ? 0.15 : 0.35), .clear], center: .center, startRadius: 10, endRadius: 180)
                    .frame(width: 350, height: 350)
                    .offset(x: moveGradient ? -70 : 70, y: moveGradient ? -90 : 90)
                
                RadialGradient(colors: [Color.primaryApp.opacity(colorScheme == .dark ? 0.15 : 0.35), .clear], center: .center, startRadius: 10, endRadius: 220)
                    .frame(width: 450, height: 450)
                    .offset(x: moveGradient ? 90 : -90, y: moveGradient ? 110 : -110)
            }
            .blur(radius: 65)
            .animation(.easeInOut(duration: 9.0).repeatForever(autoreverses: true), value: moveGradient)
            .onAppear {
                moveGradient = true
            }
        }
        .ignoresSafeArea()
    }
}
