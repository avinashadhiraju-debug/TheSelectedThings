//
//  PrivacyPolicyView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

// Struct to represent a policy section
struct PolicySection: Identifiable {
    let id: String
    let title: String
    let icon: String
    let content: String
}

struct PrivacyPolicyView: View {
    // Array of privacy sections
    let sections = [
        PolicySection(
            id: "sec_overview",
            title: "Overview",
            icon: "doc.text.fill",
            content: "At The Selected Things, we honor the architectural beauty of privacy. We are committed to safeguarding your personal data with the same careful consideration we apply to curating physical masterpieces. This policy details how we process the minimal data required to deliver our bespoke visual archive experience."
        ),
        PolicySection(
            id: "sec_data",
            title: "Data We Collect",
            icon: "square.and.pencil",
            content: "We only record information essential for high-fidelity service delivery. This includes:\n\n• Identity Details: Username, email address, and encrypted security keys required for account integrity.\n\n• Preference Logs: Sourced pieces, bookmarked designs, and categories matching your wabi-sabi, mid-century, or industrial preferences.\n\n• Logistical Metrics: General shipping destinations needed to estimate white-glove transport fees."
        ),
        PolicySection(
            id: "sec_usage",
            title: "How We Use Data",
            icon: "gearshape.fill",
            content: "Your configurations are processed strictly to personalize your curation gallery. We use this information to:\n\n• Custom-configure your Discover stream according to design preferences.\n\n• Facilitate direct inquiry and communication with our master woodworking and stone ateliers.\n\n• Send requested seasonal spotlights or digests. We NEVER sell or license your curation logs to third-party databases."
        ),
        PolicySection(
            id: "sec_security",
            title: "Encryption & Security",
            icon: "lock.shield.fill",
            content: "All account parameters, transaction logs, and communications are fully encrypted in transit and at rest. We utilize industrial-grade security protocols (AES-256) to ensure that your curated architecture files and user identity details remain entirely private."
        ),
        PolicySection(
            id: "sec_rights",
            title: "Your Curation Rights",
            icon: "hand.raised.fill",
            content: "You retain absolute ownership over your archive profile. You can:\n\n• Request full exportation of your saved preferences and account details.\n\n• Modify or delete your information directly from the 'My Details' dashboard.\n\n• Terminate your account permanently, which instantly deletes all metadata from our databases."
        )
    ]
    
    @State private var activeSectionId: String = "sec_overview"
    
    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header editorial block
                VStack(spacing: 8) {
                    Text("LEGAL ARCHIVE")
                        .font(.customfont(.bold, fontSize: 11))
                        .foregroundColor(.primaryApp)
                        .tracking(3)
                    
                    Text("Privacy Policy")
                        .font(.customfont(.bold, fontSize: 30))
                        .foregroundColor(Color(hex: "F3F3F3"))
                    
                    Text("Last updated: May 2026")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(Color(hex: "AAAAAA"))
                        .italic()
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Horizontal quick-jump anchor menu
                ScrollViewReader { anchorProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sections) { sec in
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        activeSectionId = sec.id
                                        anchorProxy.scrollTo(sec.id, anchor: .top)
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: sec.icon)
                                            .font(.system(size: 11))
                                        
                                        Text(sec.title)
                                            .font(.customfont(.bold, fontSize: 13))
                                    }
                                    .foregroundColor(activeSectionId == sec.id ? Color(hex: "0D0D0D") : Color(hex: "CCCCCC"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        activeSectionId == sec.id ? Color.primaryApp : Color.white.opacity(0.02)
                                    )
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                activeSectionId == sec.id ? Color.primaryApp : Color.white.opacity(0.06),
                                                lineWidth: 1
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                    
                    // Main Scrollable Policy Document
                    ScrollView(showsIndicators: false) {
                        ScrollViewReader { scrollProxy in
                            LazyVStack(spacing: 20) {
                                ForEach(sections) { sec in
                                    VStack(alignment: .leading, spacing: 14) {
                                        HStack(spacing: 10) {
                                            Image(systemName: sec.icon)
                                                .font(.system(size: 16))
                                                .foregroundColor(.primaryApp)
                                            
                                            Text(sec.title)
                                                .font(.customfont(.bold, fontSize: 18))
                                                .foregroundColor(Color(hex: "F3F3F3"))
                                        }
                                        .id(sec.id) // Essential anchor point for ScrollViewReader
                                        
                                        Text(sec.content)
                                            .font(.customfont(.medium, fontSize: 14))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                            .lineSpacing(6)
                                    }
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white.opacity(0.02))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                activeSectionId == sec.id
                                                    ? Color.primaryApp.opacity(0.25)
                                                    : Color.white.opacity(0.06),
                                                lineWidth: 1
                                            )
                                    )
                                }
                                
                                // Footer Legal Note
                                VStack(spacing: 8) {
                                    Divider()
                                        .background(Color.white.opacity(0.08))
                                        .padding(.bottom, 10)
                                    
                                    Text("Questions regarding this policy?")
                                        .font(.customfont(.medium, fontSize: 13))
                                        .foregroundColor(Color(hex: "888888"))
                                    
                                    Text("privacy@selectedthings.com")
                                        .font(.customfont(.bold, fontSize: 13))
                                        .foregroundColor(.primaryApp)
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 30)
                            }
                            .padding(.horizontal, 20)
                            // Hook tracking scroll offset or manual updates to link scroll location to header states
                            .onChange(of: activeSectionId) { _, newId in
                                withAnimation {
                                    scrollProxy.scrollTo(newId, anchor: .top)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyPolicyView()
        }
        .preferredColorScheme(.dark)
    }
}
