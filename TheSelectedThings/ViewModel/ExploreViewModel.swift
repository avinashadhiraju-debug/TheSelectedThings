//
//  ExploreViewModel.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    static var shared: ExploreViewModel = ExploreViewModel()
    
    @Published var txtSearch: String = ""
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var listArr: [ExploreCategoryModel] = []
    
    var filteredListArr: [ExploreCategoryModel] {
        if txtSearch.isEmpty {
            return listArr
        }
        return listArr.filter { $0.name.localizedCaseInsensitiveContains(txtSearch) }
    }
    
    init() {
        serviceCallList()
    }
    
    //MARK: ServiceCall
    func serviceCallList(){
        ServiceCall.post(parameter: [:], path: Globs.SV_EXPLORE_LIST, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    let items = (response.value(forKey: KKey.payload) as? NSArray ?? []).map({ obj in
                        return ExploreCategoryModel(dict: obj as? NSDictionary ?? [:])
                    })
                    
                    DispatchQueue.main.async {
                        self.listArr = items.isEmpty ? self.getStaticCategories() : items
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
        self.listArr = getStaticCategories()
    }
    
    func getStaticCategories() -> [ExploreCategoryModel] {
        return [
            ExploreCategoryModel(id: 1, name: "Furniture", image: "home", color: Color(hex: "F2EFE9")),
            ExploreCategoryModel(id: 2, name: "Lighting", image: "help", color: Color(hex: "EAEAEA")),
            ExploreCategoryModel(id: 3, name: "Audio", image: "a_about", color: Color(hex: "E5EAF0")),
            ExploreCategoryModel(id: 4, name: "Technology", image: "search", color: Color(hex: "EFEFEF")),
            ExploreCategoryModel(id: 5, name: "Timepieces", image: "close", color: Color(hex: "F2EFEF")),
            ExploreCategoryModel(id: 6, name: "Objects", image: "favorate", color: Color(hex: "F2F5EF"))
        ]
    }
}
