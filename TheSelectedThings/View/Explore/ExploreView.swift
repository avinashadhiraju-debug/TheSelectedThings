//
//  ExploreView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var explorVM = ExploreViewModel.shared
    
    // Sleek 2-column grid matching modern lookbook layout
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            // Elegant background
            Color.bgDetail
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Premium Lookbook Search Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("EXPLORE COLLECTIONS")
                        .font(.customfont(.bold, fontSize: 22))
                        .foregroundColor(.secondaryText)
                        .tracking(2.5)
                        .padding(.top, .topInsets + 15)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                
                // 2. Search Field
                SearchTextField(placholder: "Search collections...", txt: $explorVM.txtSearch)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                // 3. Category Grid List
                if explorVM.filteredListArr.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 40))
                            .foregroundColor(.secondaryText.opacity(0.35))
                        Text("No collections found")
                            .font(.customfont(.bold, fontSize: 16))
                            .foregroundColor(.primaryText)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(explorVM.filteredListArr, id: \.id) { catObj in
                                NavigationLink(destination: ExploreItemsView(itemsVM: ExploreItemViewModel(catObj: catObj))) {
                                    ExploreCategoryCell(cObj: catObj)
                                        .aspectRatio(0.95, contentMode: .fill)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .padding(.bottom, .bottomInsets + 90)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreView()
        }
    }
}
