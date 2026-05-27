//
//  WelcomeView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 30/07/23.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var router = AuthRouter.shared
    @State private var isIntroRunning = true
    @State private var currentGreetingIndex = 0
    @State private var greetingOpacity = 0.0
    @State private var greetingScale = 0.8
    @State private var showMainContent = false
    @State private var introTask: Task<Void, Never>? = nil
    
    private var isInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
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
            AuthBackgroundView() // SINGLE STATIC ANIMATED BACKGROUND
            
            // Onboarding views layered on top
            Group {
                if let currentScreen = router.path.last {
                    switch currentScreen {
                    case .signIn:
                        SignInView()
                    case .login:
                        LoginView()
                    case .signUp:
                        SignUpView()
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .otp:
                        OTPView()
                    case .forgotPasswordSet:
                        ForgotPasswordSetView()
                    }
                } else {
                    // Root Onboarding UI
                    ZStack {
                        // 1. Cinematic Greeting Layer (Centered multilingual introductions)
                        if isIntroRunning {
                            VStack(alignment: .center, spacing: 0) {
                                Spacer()
                                
                                Text(greetings[currentGreetingIndex])
                                    .font(.customfont(.bold, fontSize: 56))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .scaleEffect(greetingScale)
                                    .animation(nil, value: greetingScale)
                                    .opacity(greetingOpacity)
                                    .animation(nil, value: greetingOpacity)
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
                            VStack(alignment: .center, spacing: 12) {
                                Spacer()
                                
                                Image("app_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .padding(.bottom, 12)
                                
                                Text("Selected Things")
                                    .font(.customfont(.semibold, fontSize: 48))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: Color.primaryApp.opacity(0.35), radius: 12, x: 0, y: 0)
                                    .padding(.bottom, 2)
                                
                                VStack(alignment: .center, spacing: 16) {
                                    Text("Welcome to Our Crafted Experiences")
                                        .font(.customfont(.medium, fontSize: 20))
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.bottom, 30)
                                    
                                    RoundButton(title: "Get Started", isAdaptive: false) {
                                        router.navigate(to: .signIn)
                                    }
                                    .frame(maxWidth: 300, minHeight: 52)
                                    .contentShape(Rectangle())
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.opacity)
                        }
                    }
                }
            }
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .trailing)),
                removal: .opacity.combined(with: .move(edge: .leading))
            ))
            
            // Custom Premium Back Button
            if !router.path.isEmpty {
                VStack {
                    HStack {
                        Button {
                            router.navigateBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        }
                        .padding(.leading, 20)
                        .padding(.top, .topInsets + 8)
                        
                        Spacer()
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture(minimumDistance: 15, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 80 && value.startLocation.x < 50 {
                        router.navigateBack()
                    }
                }
        )
        .onAppear {
            if isInPreview {
                // In Xcode previews, avoid intro animations and show final layout
                self.isIntroRunning = false
                self.showMainContent = true
                self.greetingOpacity = 1.0
                self.greetingScale = 1.0
                return
            }
            
            runIntroAnimation()
            
            // Set native iOS navigation bar styling globally for standard back buttons
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().tintColor = .white
        }
        .onDisappear {
            introTask?.cancel()
        }
    }
    
    private func runIntroAnimation() {
        guard isIntroRunning else { return }
        
        introTask?.cancel()
        
        introTask = Task {
            for index in 0..<greetings.count {
                if Task.isCancelled { return }
                
                self.currentGreetingIndex = index
                
                withAnimation(.easeOut(duration: 0.45)) {
                    self.greetingOpacity = 1.0
                    self.greetingScale = 1.0
                }
                
                if index == self.greetings.count - 1 {
                    // Let the final greeting ("Welcome") settle, then seamlessly transition
                    do {
                        try await Task.sleep(nanoseconds: 950_000_000) // 0.95 seconds
                    } catch {
                        return
                    }
                    if Task.isCancelled { return }
                    
                    withAnimation(.easeInOut(duration: 0.65)) {
                        self.isIntroRunning = false
                        self.showMainContent = true
                    }
                } else {
                    // Regular transition for the intermediate multilingual hello greetings
                    do {
                        try await Task.sleep(nanoseconds: 700_000_000) // 0.7 seconds
                    } catch {
                        return
                    }
                    if Task.isCancelled { return }
                    
                    withAnimation(.easeIn(duration: 0.35)) {
                        self.greetingOpacity = 0.0
                        self.greetingScale = 1.1
                    }
                    
                    do {
                        try await Task.sleep(nanoseconds: 350_000_000) // 0.35 seconds
                    } catch {
                        return
                    }
                    if Task.isCancelled { return }
                    
                    self.greetingScale = 0.8
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}

struct AuthBackgroundView: View {
    @ObservedObject var mainVM = MainViewModel.shared
    @State private var moveGradient = false
    
    var body: some View {
        let isSettled = mainVM.isSettlingBackground
        let isLight = mainVM.isDarkMode == false
        
        // Base color morphing: transitioning from onboarding dark mode base to final home base (black or white)
        let baseColor: Color = isSettled ? (isLight ? .white : .black) : .black
        
        // Blob 1: Morph to bottom-right, expand radius and size, adjust opacity to match Home screen exactly
        let blob1Opacity: Double = isSettled ? (isLight ? 0.4 : 0.2) : 0.35
        let blob1Width: CGFloat = isSettled ? 500 : 350
        let blob1OffsetX: CGFloat = isSettled ? .screenWidth * 0.4 : (moveGradient ? -80 : 80)
        let blob1OffsetY: CGFloat = isSettled ? .screenHeight * 0.4 : (moveGradient ? -100 : 100)
        let blob1Scale: CGFloat = isSettled ? 1.0 : (moveGradient ? 1.25 : 0.8)
        let blob1Radius: CGFloat = isSettled ? 250 : 180
        
        // Blob 2: Smoothly fade out completely as we transition to the Home screen
        let blob2Opacity: Double = isSettled ? 0.0 : 0.25
        let blob2OffsetX: CGFloat = isSettled ? .screenWidth * 0.4 : (moveGradient ? 100 : -100)
        let blob2OffsetY: CGFloat = isSettled ? .screenHeight * 0.4 : (moveGradient ? 120 : -120)
        let blob2Scale: CGFloat = isSettled ? 0.5 : (moveGradient ? 0.75 : 1.3)
        
        ZStack {
            baseColor
                .animation(.easeInOut(duration: 0.8), value: isSettled)
                .animation(.easeInOut(duration: 0.8), value: isLight)
            
            ZStack {
                // Blob 1 (ambient glow that settles into the bottom-right corner)
                RadialGradient(colors: [Color.primaryApp.opacity(blob1Opacity), .clear], center: .center, startRadius: 10, endRadius: blob1Radius)
                    .frame(width: blob1Width, height: blob1Width)
                    .offset(x: blob1OffsetX, y: blob1OffsetY)
                    .scaleEffect(blob1Scale)
                    .animation(.easeInOut(duration: 0.8), value: isSettled)
                
                // Blob 2 (secondary floating glow that dissolves seamlessly)
                RadialGradient(colors: [Color.primaryApp.opacity(blob2Opacity), .clear], center: .center, startRadius: 10, endRadius: 220)
                    .frame(width: 450, height: 450)
                    .offset(x: blob2OffsetX, y: blob2OffsetY)
                    .scaleEffect(blob2Scale)
                    .animation(.easeInOut(duration: 0.8), value: isSettled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .blur(radius: 50)
            .blendMode(isLight ? .normal : .screen)
            .drawingGroup()
            .animation(.easeInOut(duration: 0.8), value: isLight)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 6.5).repeatForever(autoreverses: true)) {
                moveGradient = true
            }
        }
    }
}

import Combine

enum AuthPath: Hashable {
    case signIn
    case login
    case signUp
    case forgotPassword
    case otp
    case forgotPasswordSet
}

@MainActor
class AuthRouter: ObservableObject {
    static let shared = AuthRouter()
    
    @Published var path: [AuthPath] = []
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Automatically synchronize forgot password transitions based on ForgotPasswordViewModel states
        ForgotPasswordViewModel.shared.$showVerify
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showVerify in
                guard let self = self else { return }
                if showVerify {
                    if self.path.last != .otp {
                        self.navigate(to: .otp)
                    }
                }
            }
            .store(in: &cancellables)
            
        ForgotPasswordViewModel.shared.$showSetPassword
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showSetPassword in
                guard let self = self else { return }
                if showSetPassword {
                    if self.path.last != .forgotPasswordSet {
                        self.navigate(to: .forgotPasswordSet)
                    }
                } else {
                    if self.path.last == .forgotPasswordSet {
                        self.popToRootOrLogin()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func navigate(to destination: AuthPath) {
        if path.last == destination { return }
        withAnimation(.easeInOut(duration: 0.45)) {
            path.append(destination)
        }
    }
    
    func navigateBack() {
        withAnimation(.easeInOut(duration: 0.45)) {
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
    
    func popToRoot() {
        withAnimation(.easeInOut(duration: 0.45)) {
            path.removeAll()
        }
    }
    
    func popToRootOrLogin() {
        withAnimation(.easeInOut(duration: 0.45)) {
            if let loginIndex = path.firstIndex(of: .login) {
                path = Array(path[...loginIndex])
            } else {
                path.removeAll()
            }
        }
    }
}

