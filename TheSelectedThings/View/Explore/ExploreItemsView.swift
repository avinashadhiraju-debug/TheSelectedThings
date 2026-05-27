//
//  ExploreItemsView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct ExploreItemsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var itemsVM = ExploreItemViewModel(catObj: ExploreCategoryModel(dict: [:]))
    
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
                // Header with custom back button
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primaryText)
                    }
                    .frame(width: 40, height: 40)
                    
                    Spacer()
                    
                    Text(itemsVM.cObj.name)
                        .font(.customfont(.bold, fontSize: 18))
                        .foregroundColor(.primaryText)
                        .tracking(1.0)
                        .frame(height: 46)
                    
                    Spacer()
                    
                    // Balanced placeholder
                    Spacer()
                        .frame(width: 40, height: 40)
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 15)
                .background(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.01), radius: 3, x: 0, y: 2)
                
                // Showroom items grid
                if itemsVM.listArr.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "square.dashed")
                            .font(.system(size: 40))
                            .foregroundColor(.secondaryText.opacity(0.35))
                        Text("No pieces in this collection")
                            .font(.customfont(.bold, fontSize: 16))
                            .foregroundColor(.primaryText)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(itemsVM.listArr, id: \.id) { product in
                                ProductCell(pObj: product)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .padding(.bottom, .bottomInsets + 30)
                    }
                }
            }
        }
        .alert(isPresented: $itemsVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(itemsVM.errorMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct ExploreItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreItemsView(itemsVM: ExploreItemViewModel(catObj: ExploreCategoryModel(id: 1, name: "Furniture", image: "home", color: .black)))
        }
    }
}
