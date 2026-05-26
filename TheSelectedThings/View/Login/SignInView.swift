//
//  SignInView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 30/07/23.
//

import SwiftUI

struct SignInView: View {
    @State var txtMobile: String = ""
    @State private var showLogin = false
    @State private var showSignUp = false

    var body: some View {
        ZStack {
            AuthBackgroundView()
            
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
                    
                    Text("Discover beautifully\ndesigned selected things")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, .screenWidth * 0.08)
                    
                    HStack(spacing: 20) {
                        RoundButton(title: "Sign In") {
                            showLogin = true
                        }
                        .frame(maxWidth: .infinity)

                        RoundButton(title: "Sign Up") {
                            showSignUp = true
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 16)
                    .navigationDestination(isPresented: $showLogin) {
                        LoginView()
                    }
                    .navigationDestination(isPresented: $showSignUp) {
                        SignUpView()
                    }
                    
                    Spacer()
                    
                    Button {
                        MainViewModel.shared.loginAsGuest()
                    } label: {
                        Text("Browse as Guest")
                            .font(.customfont(.semibold, fontSize: 22))
                            .foregroundColor(.white.opacity(0.6))
                            .underline()
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                    
                    Text("Or connect with social media")
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 25)
                    
                    // Google Button with 4-color brand gradient shadow
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(hex: "4285F4"), // Google Blue
                                Color(hex: "EA4335"), // Google Red
                                Color(hex: "FBBC05"), // Google Yellow
                                Color(hex: "34A853")  // Google Green
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .cornerRadius(30)
                        .blur(radius: 12)
                        .opacity(0.6)
                        .offset(y: 4)
                        
                        RoundButton2(title: "Continue with Google", image: "google_logo") {
                            // Google Login Action
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                    // Facebook Button with brand single-color shadow
                    ZStack {
                        Color(hex: "1877F2") // Facebook Blue
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                            .cornerRadius(30)
                            .blur(radius: 12)
                            .opacity(0.6)
                            .offset(y: 4)
                        
                        RoundButton2(title: "Continue with Facebook", image: "facebook_logo") {
                            // Facebook Login Action
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                .frame(width: .screenWidth, alignment: .leading)
                .padding(.bottom, .bottomInsets + 20)
            }
        }
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}

