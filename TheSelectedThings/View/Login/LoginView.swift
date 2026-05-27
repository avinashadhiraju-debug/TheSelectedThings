//
//  LoginView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 01/08/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var loginVM = MainViewModel.shared

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
                    
                    Text("Log In")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                        .padding(.bottom, 4)
                    
                    Text("Enter your email and password")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, .screenWidth * 0.08)
                    
                    LineTextField(title: "Email", placeholder: "Enter your email address", txt: $loginVM.txtEmail, keyboardType: .emailAddress, textColor: .white)
                        .padding(.bottom, .screenWidth * 0.07)
                    
                    LineSecureField(title: "Password", placeholder: "Enter your password", txt: $loginVM.txtPassword, isShowPassword: $loginVM.isShowPassword, textColor: .white)
                        .padding(.bottom, .screenWidth * 0.02)
                    
                    Button {
                        AuthRouter.shared.navigate(to: .forgotPassword)
                    } label: {
                        Text("Forgot Password?")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, .screenWidth * 0.05)
                    
                    RoundButton(title: "Log In", isAdaptive: false) {
                        loginVM.serviceCallLogin()
                    }
                    .padding(.bottom, .screenWidth * 0.06)
                    
                    HStack {
                        Spacer()
                        Button {
                            AuthRouter.shared.navigate(to: .signUp)
                        } label: {
                            HStack {
                                Text("Don’t have an account?")
                                    .font(.customfont(.semibold, fontSize: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("Signup")
                                    .font(.customfont(.semibold, fontSize: 14))
                                    .foregroundColor(.primaryApp)
                            }
                        }
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 20)
                .frame(width: .screenWidth, alignment: .leading)
                .padding(.bottom, .bottomInsets + 20)
            }
        }
        .alert(isPresented: $loginVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(loginVM.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
