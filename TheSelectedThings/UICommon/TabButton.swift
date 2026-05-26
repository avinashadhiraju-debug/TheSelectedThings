//
//  TabButton.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 04/08/23.
//

import SwiftUI

struct TabButton: View {
    @State var title: String = "Title"
    @State var icon: String = "store_tab"
    @State var isSelect: Bool = false
    var didTap: (() -> ())?
    
    var body: some View {
        Button {
            didTap?()
        } label: {
            VStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isSelect ? .primaryApp : .darkGray)
                
                Text(title)
                    .font(.customfont(.semibold, fontSize: 12))
                    .foregroundColor(isSelect ? .primaryApp : .darkGray)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .scaleEffect(isSelect ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelect)
        }
    }
}
