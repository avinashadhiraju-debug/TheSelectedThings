//
//  ProductDetailViewModel.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 05/08/23.
//

import SwiftUI

class ProductDetailViewModel: ObservableObject
{
    @Published var pObj: ProductModel = ProductModel(dict: [:])
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var nutritionArr: [NutritionModel] = []
    @Published var imageArr: [ImageModel] = []
    
    
    @Published var isFav: Bool = false
    @Published var isShowDetail: Bool = false
    @Published var isShowNutrition: Bool = false
    @Published var qty: Int = 1
    
    func showDetail(){
        isShowDetail = !isShowDetail
    }
    
    func showNutrition(){
        isShowNutrition = !isShowNutrition
    }
    
    func addSubQTY(isAdd: Bool = true) {
        if(isAdd) {
            qty += 1
            if(qty > 99) {
                qty = 99
            }
        }else{
            qty -= 1
            if(qty < 1) {
                qty = 1
            }
        }
    }
    
    
    init(prodObj: ProductModel) {
        self.pObj = prodObj
        self.isFav = FavouriteViewModel.shared.isFavorite(productId: prodObj.id) || prodObj.isFav
        serviceCallDetail()
    }
    
    //MARK: ServiceCall
    
    func serviceCallDetail(){
        ServiceCall.post(parameter: ["prod_id": self.pObj.prodId ], path: Globs.SV_PRODUCT_DETAIL, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    if let payloadObj = response.value(forKey: KKey.payload) as? NSDictionary {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let product = ProductModel(dict: payloadObj)
                            
                            let nutritions = (payloadObj.value(forKey: "nutrition_list") as? NSArray ?? []).map({ obj in
                                return NutritionModel(dict: obj as? NSDictionary ?? [:])
                            })
                            
                            let images = (payloadObj.value(forKey: "images") as? NSArray ?? []).map({ obj in
                                return ImageModel(dict: obj as? NSDictionary ?? [:])
                            })
                            
                            DispatchQueue.main.async {
                                self.pObj = product
                                self.nutritionArr = nutritions
                                self.imageArr = images
                            }
                        }
                    }
                    
                }else{
                    self.errorMessage = response.value(forKey: KKey.message) as? String ?? "Fail"
                    self.showError = true
                }
            }
        } failure: { error in
            self.errorMessage = error?.localizedDescription ?? "Fail"
            self.showError = true
        }
    }
    
    func serviceCallAddRemoveFav(){
        FavouriteViewModel.shared.toggleFavorite(product: self.pObj)
        self.isFav = FavouriteViewModel.shared.isFavorite(productId: self.pObj.id)
        FavouriteViewModel.shared.serviceCallAddRemoveFav(productId: self.pObj.prodId)
    }
    
    
}
