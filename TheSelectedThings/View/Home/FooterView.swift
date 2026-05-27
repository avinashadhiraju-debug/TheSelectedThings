//
//  FooterView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        VStack(spacing: 24) {
            // 1. Premium Brand Header
            VStack(spacing: 8) {
                Image("app_logo")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.primaryText)
                    .padding(8)
                    .glassEffect(.regular, in: Circle())
                
                Text("THE SELECTED THINGS")
                    .font(.customfont(.bold, fontSize: 12))
                    .foregroundColor(.primaryText)
                    .tracking(3.0)
            }
            .padding(.top, 10)
            
            // 2. About Curatorial Blurb
            Text("We believe in the power of clean lines, functional elegance, and timeless craftsmanship. The Selected Things is an interactive lookbook highlighting design masterpieces from the world's most brilliant creators.")
                .font(.customfont(.medium, fontSize: 13))
                .foregroundColor(.secondaryText)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            
            // 3. High-Fidelity Social Icons Row
            HStack(spacing: 12) {
                SocialIcon(imageName: "facebook_logo", urlString: "https://www.facebook.com")
                SocialIcon(imageName: "instagram_logo", urlString: "https://www.instagram.com")
                SocialIcon(imageName: "reddit_logo", urlString: "https://www.reddit.com")
                SocialIcon(imageName: "x_logo", urlString: "https://www.x.com")
                SocialIcon(imageName: "youtube_logo", urlString: "https://www.youtube.com")
            }
            
            // 4. About Us & Support Links
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("ABOUT US")
                        .font(.customfont(.bold, fontSize: 10))
                        .foregroundColor(.primaryText)
                        .tracking(2.0)
                        .padding(.bottom, 2)
                    
                    FooterNavigationLink(label: "Our Story", destination: OurStoryView())
                    FooterNavigationLink(label: "Lookbook", destination: LookbookView())
                }

                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("SUPPORT")
                        .font(.customfont(.bold, fontSize: 10))
                        .foregroundColor(.primaryText)
                        .tracking(2.0)
                        .padding(.bottom, 2)
                    
                    FooterNavigationLink(label: "Contact Us", destination: ContactUsView())
                    FooterNavigationLink(label: "FAQ", destination: FAQView())
                    FooterNavigationLink(label: "Privacy Policy", destination: PrivacyPolicyView())
                }
            }
            .padding(.horizontal, 10)

            // 5. Copyright & Footnotes
            VStack(spacing: 4) {
                Text("© 2026 The Selected Things. All rights reserved.")
                    .font(.customfont(.bold, fontSize: 10))
                    .foregroundColor(.secondaryText.opacity(0.5))
                
                Text("Timeless Aesthetics • Version 1.0.2")
                    .font(.customfont(.medium, fontSize: 9))
                    .foregroundColor(.secondaryText.opacity(0.3))
                    .tracking(1.0)
            }
            .padding(.bottom, 10)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
}

// MARK: - Social Icon Subview
struct SocialIcon: View {
    let imageName: String
    let urlString: String

    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
        .frame(width: 44, height: 44)
        .buttonStyle(.glass)
    }
}

// MARK: - Footer Navigation Link Helper
struct FooterNavigationLink<Destination: View>: View {
    let label: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .font(.customfont(.medium, fontSize: 12))
                .foregroundColor(.secondaryText)
        }
        .simultaneousGesture(TapGesture().onEnded {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        })
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.bgDetail
            .ignoresSafeArea()
        
        ScrollView {
            FooterView()
        }
    }
}
