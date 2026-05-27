//
//  HomeView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject private var homeVM: HomeViewModel
    @Environment(\.colorScheme) var colorScheme

    init(homeVM: HomeViewModel = .shared) {
        _homeVM = StateObject(wrappedValue: homeVM)
    }
    
    // Namespace for premium category sliding capsule transition
    @Namespace private var categoryNamespace
    
    // State to drive hero card pressed animation
    @State private var isHeroPressed = false
    
    // Adaptive 2-column grid layout for lookbook cards
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            // Highly performant, adaptive ambient glow background
            HomeBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // 1. Premium Lookbook Header
                    headerSection

                    // 2. Featured Hero: Design of the Day
                    if homeVM.selectedCategory == "All" {
                        heroSection
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(y: -10)),
                                removal: .opacity.combined(with: .offset(y: -10))
                            ))
                    }

                    // 4. Categorized Filtering Tabs
                    categoryFilterSection

                    // 5. Lookbook Grid Feed
                    gridSection

                    // 6. Curated horizontal shelves (All category only)
                    if homeVM.selectedCategory == "All" {
                        topPicksSection
                        mostViewedSection
                        recentlyAddedSection
                    }

                    // 7. Footer
                    FooterView()
                }
                .padding(.bottom, 100)
                .animation(.spring(response: 0.38, dampingFraction: 0.82), value: homeVM.selectedCategory)
            }
        }
        .alert(isPresented: $homeVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(homeVM.errorMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        // FIX: Only ignore the top safe area so the ScrollView doesn't bleed off the bottom
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Subviews
    
    // 1. Header Section
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("SELECTED THINGS")
                    .font(.customfont(.bold, fontSize: 13))
                    .foregroundColor(.secondaryText)
                    .tracking(2.5)
                
                Text("The Lookbook")
                    .font(.customfont(.bold, fontSize: 32))
                    .foregroundColor(.primaryText)
            }
            
            Spacer()
            
            // Beautiful circular glassmorphic app logo
            Image("app_logo")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.primaryText)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.cardBackground)
                )
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .padding(.horizontal, 20)
        // Adjust this if your top safe area padding feels too large now
        .padding(.top, 60)
        .padding(.bottom, 15)
    }
    
    // 2. Hero Section (Design of the Day)
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
                            .frame(maxWidth: .infinity)
                            .frame(height: 240)
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
                    .background(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.01))
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.03))
                )
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.primaryText.opacity(colorScheme == .dark ? 0.25 : 0.08), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .scaleEffect(isHeroPressed ? 0.97 : 1.0)
                .animation(.spring(response: 0.28, dampingFraction: 0.72), value: isHeroPressed)
                .contentShape(RoundedRectangle(cornerRadius: 20))
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
                    CategoryButton(name: "All", isSelected: homeVM.selectedCategory == "All", namespace: categoryNamespace) {
                        homeVM.selectedCategory = "All"
                    }
                    ForEach(homeVM.typeArr, id: \.id) { type in
                        CategoryButton(name: type.name, isSelected: homeVM.selectedCategory == type.name, namespace: categoryNamespace) {
                            homeVM.selectedCategory = type.name
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 20)
    }
    
    // 5. Grid section
    private var gridSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(homeVM.selectedCategory == "All" ? "Selected Masterpieces" : "\(homeVM.selectedCategory) Collection")
                    .font(.customfont(.bold, fontSize: 18))
                    .foregroundColor(.primaryText)
                    .contentTransition(.opacity)

                Spacer()

                Text("\(homeVM.filteredListArr.count) items")
                    .font(.customfont(.semibold, fontSize: 12))
                    .foregroundColor(.secondaryText)
                    .contentTransition(.numericText())
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
                .id(homeVM.selectedCategory)
                .transition(.opacity)
                .padding(.horizontal, 20)
            }
        }
    }
    
    // Horizontal shelf sections
    @ViewBuilder private var topPicksSection: some View {
        if !homeVM.listArr.isEmpty {
            curatedShelf(
                title: "Top Picks",
                subtitle: "Editor's selection",
                products: Array(homeVM.listArr.prefix(6))
            )
        }
    }

    @ViewBuilder private var mostViewedSection: some View {
        let mid = homeVM.listArr.count / 2
        if homeVM.listArr.count > 2 {
            curatedShelf(
                title: "Most Viewed",
                subtitle: "Trending right now",
                products: Array(homeVM.listArr.dropFirst(mid > 0 ? mid - 1 : 0).prefix(6))
            )
        }
    }

    @ViewBuilder private var recentlyAddedSection: some View {
        if homeVM.listArr.count > 1 {
            curatedShelf(
                title: "Recently Added",
                subtitle: "New arrivals",
                products: Array(homeVM.listArr.suffix(6).reversed())
            )
        }
    }

    private func curatedShelf(title: String, subtitle: String, products: [ProductModel]) -> some View {
        let pages: [[ProductModel]] = stride(from: 0, to: products.count, by: 4).map {
            Array(products[$0..<min($0 + 4, products.count)])
        }
        let screenWidth = (UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.screen.bounds.width) ?? 390
        let cellWidth = (screenWidth - 55) / 2
        let pageHeight = ceil(cellWidth * 16 / 9) * 2 + 15

        return VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.customfont(.bold, fontSize: 18))
                        .foregroundColor(.primaryText)
                    Text(subtitle)
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(.secondaryText)
                }
                Spacer()
            }
            .padding(.horizontal, 20)

            TabView {
                ForEach(Array(pages.enumerated()), id: \.offset) { _, page in
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(page, id: \.id) { product in
                            ProductCell(pObj: product)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: pageHeight + 30)
        }
        .padding(.top, 25)
        .padding(.bottom, 28)
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
            
            Text("Try selecting a different collection.")
                .font(.customfont(.regular, fontSize: 14))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }
}

// Button style to propagate press states for hero spring scaling
struct HeroButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, pressed in
                isPressed = pressed
            }
    }
}

// Standalone struct so SwiftUI skips re-rendering buttons whose inputs haven't changed
private struct CategoryButton: View {
    let name: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
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
                                .matchedGeometryEffect(id: "activeCategoryCapsule", in: namespace)
                        } else {
                            Capsule()
                                .fill(Color.black.opacity(0.03))
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HomeView(homeVM: .preview)
    }
}

// MARK: - Home Background View

struct HomeBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(hex: "000000"),
                        Color(hex: "000000"),
                        Color .primaryApp.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(hex: "FFFFFF"),
                        Color(hex: "FFFFFF"),
                        Color .primaryApp.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
    }
}
