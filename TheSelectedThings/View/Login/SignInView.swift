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
                            .frame(width: 50, height: 50)
                        Spacer()
                    }
                    .padding(.top, .topInsets + 60)
                    .padding(.bottom, .screenWidth * 0.08)
                    
                    Text("Discover beautifully\ndesigned selected things")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, .screenWidth * 0.08)
                    
                    RoundButton(title: "Continue with Email Sign In") {
                        showLogin = true
                    }
                    .navigationDestination(isPresented: $showLogin) {
                        LoginView()
                    }
                    .padding(.bottom, 8)
                    
                    RoundButton(title: "Continue with Email Sign Up") {
                        showSignUp = true
                    }
                    .navigationDestination(isPresented: $showSignUp) {
                        SignUpView()
                    }
                    .padding(.bottom, 8)
                    
                    RoundButton(title: "Browse as Guest") {
                        MainViewModel.shared.loginAsGuest()
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                        .background(Color.white.opacity(0.15))
                        .padding(.bottom, 25)
                
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
                        .opacity(0.8)
                        .offset(y: 4)
                        
                        RoundButton(title: "Continue with Google", image: "google_logo") {
                            // Google Login Action
                        }
                    }
                    .padding(.bottom, 16)
                    
                    // Facebook Button with brand single-color shadow
                    ZStack {
                        Color(hex: "1877F2") // Facebook Blue
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                            .cornerRadius(30)
                            .blur(radius: 12)
                            .opacity(0.6)
                            .offset(y: 4)
                        
                        RoundButton(title: "Continue with Facebook", image: "fb_logo") {
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
