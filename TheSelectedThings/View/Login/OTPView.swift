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
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primaryApp)
                                .padding(16)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.08))
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.primaryApp.opacity(0.60), Color.clear, Color.secondaryprimaryApp.opacity(0.60)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2.29
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                        }
                        .buttonStyle(OTPNextButtonStyle())
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

struct OTPNextButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : (isHovered ? 1.05 : 1.0))
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}
