//
//  WelcomeView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 30/07/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isIntroRunning = true
    @State private var currentGreetingIndex = 0
    @State private var greetingOpacity = 0.0
    @State private var greetingScale = 0.8
    @State private var showMainContent = false
    @State private var showSignIn = false
    
    private let greetings = [
        "Hello",       // English
        "Swagatham",     // Telugu
        "Namaste",     // Hindi
        "Hola",        // Spanish
        "Ciao",        // Italian
        "Welcome"      // Final Brand Reveal
    ]
    
    var body: some View {
        ZStack {
            AuthBackgroundView()
            
            // 1. Cinematic Greeting Layer (Centered multilingual introductions)
            if isIntroRunning {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    Text(greetings[currentGreetingIndex])
                        .font(.customfont(.bold, fontSize: 56))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .scaleEffect(greetingScale)
                        .opacity(greetingOpacity)
                        .blur(radius: (1.0 - greetingOpacity) * 8)
                        .shadow(color: Color.primaryApp.opacity(0.35), radius: 12, x: 0, y: 0)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
            }
            
            // 2. Premium Onboarding Layer (Fully structured, center-aligned, stable layout)
            if showMainContent {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 12)
                    
                    Text("Selected Things")
                        .font(.customfont(.semibold, fontSize: 48))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: Color.primaryApp.opacity(0.35), radius: 12, x: 0, y: 0)
                        .padding(.bottom, 15)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("Welcome to Our Crafted Experiences")
                            .font(.customfont(.medium, fontSize: 20))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 30)
                        
                        RoundButton(title: "Get Started") {
                            showSignIn = true
                        }
                        .navigationDestination(isPresented: $showSignIn) {
                            SignInView()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear {
            runIntroAnimation()
            
            // Set native iOS navigation bar styling globally for standard back buttons
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().tintColor = .white
        }
    }
    
    private func runIntroAnimation() {
        guard isIntroRunning else { return }
        
        let delayStep = 1.05
        
        for index in 0..<greetings.count {
            let delay = Double(index) * delayStep
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard self.isIntroRunning else { return }
                
                self.currentGreetingIndex = index
                
                withAnimation(.easeOut(duration: 0.45)) {
                    self.greetingOpacity = 1.0
                    self.greetingScale = 1.0
                }
                
                if index == self.greetings.count - 1 {
                    // Let the final greeting ("Welcome") settle, then seamlessly transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                        withAnimation(.easeInOut(duration: 0.65)) {
                            self.isIntroRunning = false
                            self.showMainContent = true
                        }
                    }
                } else {
                    // Regular transition for the intermediate multilingual hello greetings
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.easeIn(duration: 0.35)) {
                            self.greetingOpacity = 0.0
                            self.greetingScale = 1.1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            self.greetingScale = 0.8
                        }
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeView()
        }
    }
}

struct AuthBackgroundView: View {
    @State private var moveGradient = false
    
    var body: some View {
        ZStack {
            // Premium solid black base
            Color.black
                .ignoresSafeArea()
            
            // Slow animated ambient glow blobs matching primary brand design
            ZStack {
                RadialGradient(colors: [Color.primaryApp.opacity(0.35), .clear], center: .center, startRadius: 10, endRadius: 180)
                    .frame(width: 350, height: 350)
                    .offset(x: moveGradient ? -80 : 80, y: moveGradient ? -100 : 100)
                    .scaleEffect(moveGradient ? 1.25 : 0.8)
                
                RadialGradient(colors: [Color.primaryApp.opacity(0.25), .clear], center: .center, startRadius: 10, endRadius: 220)
                    .frame(width: 450, height: 450)
                    .offset(x: moveGradient ? 100 : -100, y: moveGradient ? 120 : -120)
                    .scaleEffect(moveGradient ? 0.75 : 1.3)
            }
            .blur(radius: 50)
            .blendMode(.screen)
            .onAppear {
                withAnimation(.easeInOut(duration: 6.5).repeatForever(autoreverses: true)) {
                    moveGradient = true
                }
            }
        }
        .ignoresSafeArea()
    }
}

