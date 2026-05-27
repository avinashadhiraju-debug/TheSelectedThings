//
//  FavouriteViewModel.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

class FavouriteViewModel: ObservableObject {
    static var shared: FavouriteViewModel = FavouriteViewModel()
    
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var listArr: [ProductModel] = []
    
    // In-memory cache of favorited product IDs
    @Published var favoriteIds: Set<Int> = []
    
    init() {
        serviceCallList()
    }
    
    func isFavorite(productId: Int) -> Bool {
        return favoriteIds.contains(productId)
    }
    
    func toggleFavorite(product: ProductModel) {
        if favoriteIds.contains(product.id) {
            favoriteIds.remove(product.id)
            listArr.removeAll { $0.id == product.id }
        } else {
            favoriteIds.insert(product.id)
            var favProduct = product
            favProduct.isFav = true
            listArr.append(favProduct)
        }
        
        // Synchronize with Home feed
        objectWillChange.send()
    }
    
    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: [:], path: Globs.SV_FAVORITE_LIST, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let list = (response.value(forKey: KKey.payload) as? NSArray ?? []).map({ obj in
                            return ProductModel(dict: obj as? NSDictionary ?? [:])
                        })
                        DispatchQueue.main.async {
                            self.listArr = list
                            self.favoriteIds = Set(list.map { $0.id })
                        }
                    }
                } else {
                    // Fail gracefully in offline mode, retaining local listArr
                }
            } else {
                // Fail gracefully in offline mode
            }
        } failure: { error in
            // Fail gracefully in offline mode
        }
    }
    
    func serviceCallAddRemoveFav(productId: Int) {
        ServiceCall.post(parameter: ["prod_id": productId ], path: Globs.SV_ADD_REMOVE_FAVORITE, isToken: true ) { responseObj in
            // Synchronize with backend if online, but local toggling is primary and immediate
        } failure: { error in
            // Ignore failure offline
        }
    }
}
