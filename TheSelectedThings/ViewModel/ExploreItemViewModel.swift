//
//  ExploreItemViewModel.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

class ExploreItemViewModel: ObservableObject {
    @Published var cObj: ExploreCategoryModel = ExploreCategoryModel(dict: [:])
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var listArr: [ProductModel] = []
    
    init(catObj: ExploreCategoryModel) {
        self.cObj = catObj
        serviceCallList()
    }
    
    //MARK: ServiceCall
    func serviceCallList(){
        ServiceCall.post(parameter: ["cat_id": self.cObj.id ], path: Globs.SV_EXPLORE_ITEMS_LIST, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    let items = (response.value(forKey: KKey.payload) as? NSArray ?? []).map({ obj in
                        return ProductModel(dict: obj as? NSDictionary ?? [:])
                    })
                    
                    DispatchQueue.main.async {
                        self.listArr = items.isEmpty ? self.loadStaticProducts() : items
                    }
                } else {
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
        self.listArr = loadStaticProducts()
    }
    
    func loadStaticProducts() -> [ProductModel] {
        return ProductModel.curatedProducts.filter { $0.catName.localizedCaseInsensitiveContains(self.cObj.name) }
    }
}
