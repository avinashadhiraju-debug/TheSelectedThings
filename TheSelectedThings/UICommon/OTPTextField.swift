//
//  OTPTextField.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 04/08/23.
//

import SwiftUI

struct OTPTextField: View {
    @Binding var txt: String
    var isFocused: Bool = false
    
    var body: some View {
        TextField("", text: $txt)
            .font(.customfont(.semibold, fontSize: 24))
            .multilineTextAlignment(.center)
            .padding(15)
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFocused ? Color.primaryApp : (txt.isEmpty ? Color.secondaryText : Color.primaryApp.opacity(0.5)), lineWidth: isFocused ? 2 : 1)
            )
            .keyboardType(.numberPad)
            .onChange(of: txt) {
                if txt.count > 1 {
                    txt = String(txt.prefix(1))
                }
                txt = txt.filter { $0.isNumber }
            }
            .scaleEffect(txt.isEmpty ? 1.0 : 1.05)
            .animation(.easeOut(duration: 0.15), value: txt)
    }
}

struct OTPTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        OTPTextField(txt: $txt)
    }
}
