//
//  ForgotPasswordView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 16/08/23.
//

import SwiftUI

struct ForgotPasswordView: View {
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
                    
                    Text("Forgot Password")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                        .padding(.bottom, 4)
                    
                    Text("Enter your email address")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, .screenWidth * 0.08)
                    
                    LineTextField(title: "Email", placeholder: "Enter your email address", txt: $forgotVM.txtEmail, keyboardType: .emailAddress, textColor: .white)
                        .padding(.bottom, .screenWidth * 0.07)
                    
                    RoundButton(title: "Submit", isAdaptive: false) {
                        forgotVM.serviceCallRequest()
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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ForgotPasswordView()
        }
    }
}
