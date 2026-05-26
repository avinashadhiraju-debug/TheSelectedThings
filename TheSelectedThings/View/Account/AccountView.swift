//
//  AccountView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

struct AccountView: View {
    @StateObject var mainVM = MainViewModel.shared
    
    // Saved preferences toggles
    @State private var highlightsEnabled = true
    @State private var digestsEnabled = false
    @State private var showPreferences = false
    
    var body: some View {
        ZStack {
            // Elegant background
            Color(hex: "FCFCFC")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Premium User Card
                HStack(spacing: 16) {
                    // Modern black-and-white curator avatar
                    ZStack {
                        Circle()
                            .fill(Color.primaryText.opacity(0.85))
                            .frame(width: 60, height: 60)
                        
                        Text(String(mainVM.userObj.username.prefix(1)).uppercased())
                            .font(.customfont(.bold, fontSize: 24))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mainVM.userObj.username.isEmpty ? "Guest Curator" : mainVM.userObj.username)
                            .font(.customfont(.bold, fontSize: 20))
                            .foregroundColor(.primaryText)
                        
                        Text(mainVM.userObj.email.isEmpty ? "curator@selectedthings.com" : mainVM.userObj.email)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, .topInsets + 15)
                .padding(.bottom, 20)
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // 2. Settings Group
                        VStack(alignment: .leading, spacing: 0) {
                            Text("APP PREFERENCES")
                                .font(.customfont(.bold, fontSize: 11))
                                .foregroundColor(.secondaryText)
                                .tracking(1.5)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                            
                            // Light / Dark Mode Toggle
                            HStack {
                                Image(systemName: mainVM.isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                                    .foregroundColor(.primaryText)
                                    .font(.system(size: 18))
                                    .frame(width: 28)
                                
                                Text("Dark Mode")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: $mainVM.isDarkMode)
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: .black))
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            
                            Divider()
                                .padding(.horizontal, 16)
                            
                            // Collapsible Saved Preferences
                            VStack(alignment: .leading, spacing: 0) {
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        showPreferences.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "slider.horizontal.3")
                                            .foregroundColor(.primaryText)
                                            .font(.system(size: 18))
                                            .frame(width: 28)
                                        
                                        Text("Saved Preferences")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.secondaryText)
                                            .rotationEffect(.degrees(showPreferences ? 90 : 0))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }
                                
                                if showPreferences {
                                    VStack(alignment: .leading, spacing: 14) {
                                        Toggle("Daily Highlight Digests", isOn: $highlightsEnabled)
                                            .font(.customfont(.medium, fontSize: 14))
                                            .foregroundColor(.secondaryText)
                                            .toggleStyle(SwitchToggleStyle(tint: .black))
                                        
                                        Toggle("Curator Spotlight Alerts", isOn: $digestsEnabled)
                                            .font(.customfont(.medium, fontSize: 14))
                                            .foregroundColor(.secondaryText)
                                            .toggleStyle(SwitchToggleStyle(tint: .black))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 16)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        // 3. About the Curators Card
                        VStack(alignment: .leading, spacing: 14) {
                            Text("ABOUT THE CURATORS")
                                .font(.customfont(.bold, fontSize: 11))
                                .foregroundColor(.secondaryText)
                                .tracking(1.5)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Our Curation Philosophy")
                                    .font(.customfont(.bold, fontSize: 18))
                                    .foregroundColor(.primaryText)
                                
                                Text("We believe in less, but better. Our dedicated team of architects and curators search the globe to hand-pick pieces that represent extraordinary functional aesthetics, masterful craftsmanship, and beautiful sustainability.")
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(.secondaryText)
                                    .lineSpacing(6)
                                
                                Text("This digital lookbook serves as an open archive of design-forward masterpieces, intended to be appreciated by collectors and enthusiasts who value clean lines, modern geometry, and timeless form.")
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(.secondaryText)
                                    .lineSpacing(6)
                            }
                            .padding(18)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // 4. Log Out
                        Button {
                            // Haptic Trigger
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            mainVM.logout()
                        } label: {
                            ZStack {
                                Text("Log Out")
                                    .font(.customfont(.bold, fontSize: 16))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                
                                HStack {
                                    Spacer()
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.01), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, .bottomInsets + 90)
                    }
                    .padding(.vertical, 15)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountView()
        }
    }
}
