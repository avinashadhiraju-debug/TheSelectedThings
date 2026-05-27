//
//  OTPView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 16/08/23.
//

import SwiftUI

struct OTPView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var forgotVM = ForgotPasswordViewModel.shared

    var body: some View {
        ZStack {
            // Background is transparent to let the master AuthBackgroundView flow smoothly
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Enter your 4-digit code")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                        .padding(.top, .topInsets + 60)
                        .padding(.bottom, .screenWidth * 0.08)
                    
                    LineTextField(title: "Code", placeholder: "- - - -", txt: $forgotVM.txtResetCode, keyboardType: .phonePad, textColor: .white)
                        .padding(.bottom, .screenWidth * 0.07)
                    
                    HStack {
                        Button {
                            forgotVM.serviceCallRequest()
                        } label: {
                            Text("Resend Code")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.primaryApp)
                        }
                        
                        Spacer()
                        
                        Button {
                            forgotVM.serviceCallVerify()
                        } label: {
                            Image("next")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding(15)
                        }
                        .background(Color.primaryApp)
                        .cornerRadius(30)
                    }
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

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
