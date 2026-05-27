//
//  SearchTextField.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 03/08/23.
//

import SwiftUI

struct SearchTextField: View {
    @State var placholder: String = "Placeholder"
    @Binding var txt: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 15) {
            Image("search")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
           
            TextField(text: $txt) {
                Text(placholder)
                    .foregroundColor(.placeholder)
            }
                .font(.customfont(.regular, fontSize: 18))
                .foregroundColor(.primaryText)
                .tint(.primaryText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(height: 30)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.10) : Color.black.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(
                    LinearGradient(
                        colors: [Color.primaryApp.opacity(colorScheme == .dark ? 0.3 : 0.8), Color.clear,Color.secondaryprimaryApp.opacity(colorScheme == .dark ? 0.3 : 0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
    }
}

struct SearchTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        SearchTextField(placholder: "Search Store", txt: $txt)
            .padding(15)
    }
}
