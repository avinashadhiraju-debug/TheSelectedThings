//
//  ForgotPasswordSetView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 16/08/23.
//

import SwiftUI

struct ForgotPasswordSetView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var forgotVM = ForgotPasswordViewModel.shared

    var body: some View {
        ZStack {
            // Background is transparent to let the master AuthBackgroundView flow smoothly
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Centered Logo
                    HStack {
                        Spacer()
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Spacer()
                    }
                    .padding(.top, .topInsets + 60)
                    .padding(.bottom, .screenWidth * 0.08)
                    
                    Text("Set New Password")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                        .padding(.bottom, 4)
                    
                    Text("Enter your new password")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, .screenWidth * 0.08)
                    
                    LineSecureField(title: "New Password", placeholder: "Enter your new password", txt: $forgotVM.txtNewPassword, isShowPassword: $forgotVM.isNewPassword, textColor: .white)
                        .padding(.bottom, .screenWidth * 0.02)
                    
                    LineSecureField(title: "Confirm Password", placeholder: "Enter your confirm password", txt: $forgotVM.txtConfirmPassword, isShowPassword: $forgotVM.isConfirmPassword, textColor: .white)
                        .padding(.bottom, .screenWidth * 0.04)
                    
                    RoundButton(title: "Submit", isAdaptive: false) {
                        forgotVM.serviceCallSetPassword()
                    }
                    .padding(.bottom, .screenWidth * 0.05)
                    
                }
                .padding(.horizontal, 20)
                .frame(width: .screenWidth, alignment: .leading)
                .padding(.bottom, .bottomInsets + 20)
            }
        }
        .alert(isPresented: $forgotVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(forgotVM.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

struct ForgotPasswordSetView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordSetView()
    }
}
