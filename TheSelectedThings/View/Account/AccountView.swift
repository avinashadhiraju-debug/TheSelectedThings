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
            Color(hex: "0D0D0D").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Premium User Card
                HStack(spacing: 16) {
                    // Curator avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryApp.opacity(0.85), Color.primaryApp.opacity(0.55)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(mainVM.userObj.gender.lowercased() == "male" ? "u2" : "u1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                    .shadow(color: Color.primaryApp.opacity(0.6), radius: 8, x: -4, y: -4)
                    .shadow(color: Color.blue.opacity(0.6), radius: 8, x: -4, y: -4)
                    .shadow(color: Color.pink.opacity(0.6), radius: 8, x: 4, y: 4)
                    .shadow(color: Color.brown.opacity(0.6), radius: 8, x: 4, y: 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mainVM.userObj.username.isEmpty ? "Guest Curator" : mainVM.userObj.username)
                            .font(.customfont(.bold, fontSize: 20))
                            .foregroundColor(Color(hex: "F3F3F3"))
                        
                        Text(mainVM.userObj.email.isEmpty ? "curator@selectedthings.com" : mainVM.userObj.email)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(Color(hex: "AAAAAA"))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, .topInsets + 15)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // 2. Settings Group
                        VStack(alignment: .leading, spacing: 0) {
                            Text("APP PREFERENCES")
                                .font(.customfont(.bold, fontSize: 11))
                                .foregroundColor(Color(hex: "AAAAAA"))
                                .tracking(1.5)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                // My Details row
                                NavigationLink(destination: MyDetailsView()) {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("My Details")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }
                                
                                // Notifications row
                                NavigationLink(destination: NotificationView()) {
                                    HStack {
                                        Image(systemName: "bell.fill")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("Notifications")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }
                                
                                // Saved Preferences collapsible
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        showPreferences.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "slider.horizontal.3")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 18))
                                            .frame(width: 28)
                                        
                                        Text("Saved Preferences")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                            .rotationEffect(.degrees(showPreferences ? 90 : 0))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }
                                
                                if showPreferences {
                                    VStack(alignment: .leading, spacing: 14) {
                                        Toggle("Daily Highlight Digests", isOn: $highlightsEnabled)
                                            .font(.customfont(.medium, fontSize: 14))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                            .toggleStyle(SwitchToggleStyle(tint: .primaryApp))
                                        
                                        Toggle("Curator Spotlight Alerts", isOn: $digestsEnabled)
                                            .font(.customfont(.medium, fontSize: 14))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                            .toggleStyle(SwitchToggleStyle(tint: .primaryApp))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 16)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.02))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
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
                        .padding(.horizontal, 20)
                        
                        // 2b. The Selected Archive Group
                        VStack(alignment: .leading, spacing: 0) {
                            Text("THE SELECTED ARCHIVE")
                                .font(.customfont(.bold, fontSize: 11))
                                .foregroundColor(Color(hex: "AAAAAA"))
                                .tracking(1.5)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                // Our Story row
                                NavigationLink(destination: OurStoryView()) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("Our Story")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.05))
                                    .padding(.horizontal, 16)

                                // Lookbook row
                                NavigationLink(destination: LookbookView()) {
                                    HStack {
                                        Image(systemName: "magazine.fill")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("Lookbook")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }

                                Divider()
                                    .background(Color.white.opacity(0.05))
                                    .padding(.horizontal, 16)

                                // Contact Us row
                                NavigationLink(destination: ContactUsView()) {
                                    HStack {
                                        Image(systemName: "paperplane.fill")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("Contact Us")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }

                                Divider()
                                    .background(Color.white.opacity(0.05))
                                    .padding(.horizontal, 16)

                                // FAQ row
                                NavigationLink(destination: FAQView()) {
                                    HStack {
                                        Image(systemName: "questionmark.circle.fill")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("FAQ")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }

                                Divider()
                                    .background(Color.white.opacity(0.05))
                                    .padding(.horizontal, 16)

                                // Privacy Policy row
                                NavigationLink(destination: PrivacyPolicyView()) {
                                    HStack {
                                        Image(systemName: "lock.shield.fill")
                                            .foregroundColor(.primaryApp)
                                            .font(.system(size: 16))
                                            .frame(width: 28)
                                        
                                        Text("Privacy Policy")
                                            .font(.customfont(.semibold, fontSize: 16))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.02))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
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
                        .padding(.horizontal, 20)
                        
                        // 3. About the Curators Card — dark glassmorphic
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.primaryApp)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("ABOUT THE CURATORS")
                                    .font(.customfont(.bold, fontSize: 11))
                                    .foregroundColor(Color(hex: "AAAAAA"))
                                    .tracking(1.5)
                            }

                            VStack(alignment: .leading, spacing: 10) {
                                Text("Our Curation Philosophy")
                                    .font(.customfont(.bold, fontSize: 18))
                                    .foregroundColor(Color(hex: "F3F3F3"))

                                Text("We believe in less, but better. Our dedicated team of architects and curators search the globe to hand-pick pieces that represent extraordinary functional aesthetics, masterful craftsmanship, and beautiful sustainability.")
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(Color(hex: "AAAAAA"))
                                    .lineSpacing(6)

                                Text("This digital lookbook serves as an open archive of design-forward masterpieces, intended to be appreciated by collectors and enthusiasts who value clean lines, modern geometry, and timeless form.")
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(Color(hex: "AAAAAA"))
                                    .lineSpacing(6)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(Color.primaryApp.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.primaryApp.opacity(0.35), Color.white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        // 4. Log Out
                        RoundButton2(title: "Log Out", image: "rectangle.portrait.and.arrow.right", isAdaptive: false) {
                            mainVM.logout()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, .bottomInsets + 90)
                    }
                    .padding(.vertical, 15)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountView()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
