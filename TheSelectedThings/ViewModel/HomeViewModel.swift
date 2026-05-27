//
//  HomeViewModel.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 03/08/23.
//

import SwiftUI

class HomeViewModel: ObservableObject
{
    static var shared: HomeViewModel = HomeViewModel()
    
    @Published var selectTab: Int = 0
    @Published var txtSearch: String = "" {
        didSet { updateFilteredList() }
    }

    @Published var showError = false
    @Published var errorMessage = ""

    @Published var offerArr: [ProductModel] = []
    @Published var bestArr: [ProductModel] = []
    @Published var listArr: [ProductModel] = [] {
        didSet { updateFilteredList() }
    }
    @Published var typeArr: [TypeModel] = []

    @Published var selectedCategory: String = "All" {
        didSet { updateFilteredList() }
    }

    @Published private(set) var filteredListArr: [ProductModel] = []

    private func updateFilteredList() {
        filteredListArr = listArr.filter { product in
            let matchesCategory = selectedCategory == "All" || product.catName == selectedCategory
            if !matchesCategory { return false }
            guard !txtSearch.isEmpty else { return true }
            return product.name.localizedCaseInsensitiveContains(txtSearch) ||
                   product.brandName.localizedCaseInsensitiveContains(txtSearch) ||
                   product.designer.localizedCaseInsensitiveContains(txtSearch)
        }
    }
    
    init() {
        serviceCallList()
    }
    
    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: [:], path: Globs.SV_HOME, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    if let payloadObj = response.value(forKey: KKey.payload) as? NSDictionary {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let offers = (payloadObj.value(forKey: "offer_list") as? NSArray ?? []).map({ obj in
                                return ProductModel(dict: obj as? NSDictionary ?? [:])
                            })
                            
                            let bests = (payloadObj.value(forKey: "best_sell_list") as? NSArray ?? []).map({ obj in
                                return ProductModel(dict: obj as? NSDictionary ?? [:])
                            })
                            
                            let lists = (payloadObj.value(forKey: "list") as? NSArray ?? []).map({ obj in
                                return ProductModel(dict: obj as? NSDictionary ?? [:])
                            })
                            
                            let types = (payloadObj.value(forKey: "type_list") as? NSArray ?? []).map({ obj in
                                return TypeModel(dict: obj as? NSDictionary ?? [:])
                            })
                            
                            DispatchQueue.main.async {
                                self.offerArr = offers.isEmpty ? Array(ProductModel.curatedProducts.prefix(2)) : offers
                                self.bestArr = bests.isEmpty ? Array(ProductModel.curatedProducts.suffix(3)) : bests
                                self.listArr = lists.isEmpty ? ProductModel.curatedProducts : lists
                                self.typeArr = types.isEmpty ? self.getStaticTypes() : types
                            }
                        }
                    }
                    
                }else{
                    self.loadStaticFallback()
                }
            } else {
                self.loadStaticFallback()
            }
        } failure: { error in
            self.loadStaticFallback()
        }
    }
    
    func loadStaticFallback() {
        self.offerArr = Array(ProductModel.curatedProducts.prefix(2))
        self.bestArr = Array(ProductModel.curatedProducts.dropFirst(2).prefix(2))
        self.listArr = ProductModel.curatedProducts
        self.typeArr = getStaticTypes()
    }
    
    func getStaticTypes() -> [TypeModel] {
        return [
            TypeModel(id: 1, name: "Furniture", image: "home", color: Color(hex: "1A1A1A")),
            TypeModel(id: 2, name: "Lighting", image: "help", color: Color(hex: "3A3A3A")),
            TypeModel(id: 3, name: "Audio", image: "a_about", color: Color(hex: "5A5A5A")),
            TypeModel(id: 4, name: "Technology", image: "search", color: Color(hex: "7A7A7A")),
            TypeModel(id: 5, name: "Timepieces", image: "close", color: Color(hex: "9A9A9A")),
            TypeModel(id: 6, name: "Objects", image: "favorate", color: Color(hex: "BABABA"))
        ]
    }
}

