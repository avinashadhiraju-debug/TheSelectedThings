//
//  ExploreCategoryModel.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct ExploreCategoryModel: Identifiable, Equatable {
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var color: Color = Color.primaryApp
    
    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "cat_id") as? Int ?? 0
        self.name = dict.value(forKey: "cat_name") as? String ?? ""
        self.image = dict.value(forKey: "image") as? String ?? ""
        self.color = Color(hex: dict.value(forKey: "color") as? String ?? "000000")
    }
    
    init(id: Int, name: String, image: String, color: Color) {
        self.id = id
        self.name = name
        self.image = image
        self.color = color
    }
    
    static func == (lhs: ExploreCategoryModel, rhs: ExploreCategoryModel) -> Bool {
        return lhs.id == rhs.id
    }
}
