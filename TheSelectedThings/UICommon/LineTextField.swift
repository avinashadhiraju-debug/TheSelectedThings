//
//  LineTextField.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 01/08/23.
//

import SwiftUI

struct LineTextField: View {
    var title: String = "Title"
    var placeholder: String = "Placeholder"
    @Binding var txt: String
    var keyboardType: UIKeyboardType = .default
    var textColor: Color = .primaryText
    @FocusState private var isFocused: Bool

    private var labelColor: Color {
        textColor == .primaryText ? .textTitle : textColor.opacity(0.6)
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundStyle(labelColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(text: $txt) {
                Text(placeholder)
                    .foregroundColor(textColor.opacity(0.4))
            }
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(textColor)
                .frame(height: 40)
                .focused($isFocused)

            Rectangle()
                .fill(isFocused ? Color.primaryApp : Color.placeholder.opacity(0.5))
                .frame(height: 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

struct LineSecureField: View {
    var title: String = "Title"
    var placeholder: String = "Placeholder"
    @Binding var txt: String
    @Binding var isShowPassword: Bool
    var textColor: Color = .primaryText
    @FocusState private var isFocused: Bool

    private var labelColor: Color {
        textColor == .primaryText ? .textTitle : textColor.opacity(0.6)
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundStyle(labelColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if isShowPassword {
                    TextField(text: $txt) {
                        Text(placeholder)
                            .foregroundColor(textColor.opacity(0.4))
                    }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField(text: $txt) {
                        Text(placeholder)
                            .foregroundColor(textColor.opacity(0.4))
                    }
                }
            }
            .modifier(ShowButton(isShow: $isShowPassword))
            .foregroundStyle(textColor)
            .frame(height: 40)
            .focused($isFocused)

            Rectangle()
                .fill(isFocused ? Color.primaryApp : Color.placeholder.opacity(0.5))
                .frame(height: 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    @Previewable @State var txt = ""
    LineTextField(txt: $txt)
        .padding(20)
}
