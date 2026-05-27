//
//  OurStoryView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

struct OurStoryView: View {
    var body: some View {
        ZStack {
            // Dark luxury background
            Color(hex: "0D0D0D").ignoresSafeArea()
            
            // Decorative background glowing gradients
            VStack {
                HStack {
                    Circle()
                        .fill(Color.primaryApp.opacity(0.12))
                        .frame(width: 250, height: 250)
                        .blur(radius: 80)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.secondaryprimaryApp.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 90)
                }
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    
                    // 1. Hero Editorial Section
                    VStack(spacing: 8) {
                        Text("THE ARCHIVE")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(.primaryApp)
                            .tracking(3)
                        
                        Text("Our Story")
                            .font(.customfont(.bold, fontSize: 32))
                            .foregroundColor(Color(hex: "F3F3F3"))
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.primaryApp, .secondaryprimaryApp],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 60, height: 3)
                            .padding(.top, 4)
                    }
                    .padding(.top, 20)
                    
                    // 2. The Narrative
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Born from a shared appreciation for architectural form, raw materiality, and spatial harmony, The Selected Things is a digital sanctuary for extraordinary items.")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(Color(hex: "E0E0E0"))
                            .lineSpacing(8)
                        
                        Text("We do not believe in trends. We believe in objects that command a room through quiet presence, masterful craftsmanship, and honest construction. Our mission is to curate an evolving collection of the world's most exceptional spatial designs, furnishings, and details.")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(Color(hex: "AAAAAA"))
                            .lineSpacing(6)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.02))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.08), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // 3. Core Pillars (Grid / Blocks)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("OUR GUIDING PRINCIPLES")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(Color(hex: "AAAAAA"))
                            .tracking(2)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 14) {
                            PillarRow(
                                icon: "square.stack.3d.up.fill",
                                title: "Raw Materiality",
                                description: "We highlight stone, solid wood, textured glass, and brutalist metals in their most honest, unaltered states."
                            )
                            
                            PillarRow(
                                icon: "cube.transparent.fill",
                                title: "Geometric Purity",
                                description: "Clean lines, functional symmetries, and striking proportions form the blueprint of our curated selection."
                            )
                            
                            PillarRow(
                                icon: "leaf.fill",
                                title: "Eternal Lifecycle",
                                description: "Every piece is selected for structural longevity and sustainability, designed to be inherited rather than replaced."
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // 4. Milestone Timeline
                    VStack(alignment: .leading, spacing: 20) {
                        Text("THE EVOLUTION")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(Color(hex: "AAAAAA"))
                            .tracking(2)
                            .padding(.horizontal, 24)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            TimelineNode(year: "2023", title: "Founding of the Archive", desc: "Started as an invitation-only digital archive cataloging mid-century and brutalist spatial objects.", isLast: false)
                            TimelineNode(year: "2024", title: "Global Artisan Network", desc: "Partnered directly with 18 independent ateliers across Kyoto, Copenhagen, and Portland.", isLast: false)
                            TimelineNode(year: "2025", title: "Sustainable Sourcing Mandate", desc: "Pledged full supply-chain transparency, ensuring each wood and stone item is certified circular.", isLast: false)
                            TimelineNode(year: "2026", title: "The Mobile Experience", desc: "Launched our iOS platform, enabling design collectors to seamlessly discover and acquire selected masterpieces.", isLast: true)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // 5. Curator Quote Card
                    VStack(spacing: 12) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 28))
                            .foregroundColor(.primaryApp.opacity(0.6))
                        
                        Text("Simplicity is not the lack of clutter, but the presence of clarity.")
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundColor(Color(hex: "F3F3F3"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                        
                        Text("— THE ARCHITECTURAL BOARD")
                            .font(.customfont(.bold, fontSize: 10))
                            .foregroundColor(Color(hex: "828282"))
                            .tracking(2.5)
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.primaryApp.opacity(0.04))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.primaryApp.opacity(0.3), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

// Subcomponent: Pillar Row
struct PillarRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.03))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primaryApp)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.customfont(.bold, fontSize: 15))
                    .foregroundColor(Color(hex: "F3F3F3"))
                
                Text(description)
                    .font(.customfont(.medium, fontSize: 13))
                    .foregroundColor(Color(hex: "AAAAAA"))
                    .lineSpacing(4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.01))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.03), lineWidth: 1)
        )
    }
}

// Subcomponent: Timeline Node
struct TimelineNode: View {
    let year: String
    let title: String
    let desc: String
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Timeline circle and line
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.primaryApp)
                    .frame(width: 10, height: 10)
                    .shadow(color: Color.primaryApp.opacity(0.5), radius: 4)
                
                if !isLast {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.primaryApp, .primaryApp.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 12)
            
            // Timeline Content
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(year)
                        .font(.customfont(.bold, fontSize: 14))
                        .foregroundColor(.primaryApp)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.primaryApp.opacity(0.12))
                        .cornerRadius(6)
                    
                    Text(title)
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundColor(Color(hex: "F3F3F3"))
                }
                
                Text(desc)
                    .font(.customfont(.medium, fontSize: 13))
                    .foregroundColor(Color(hex: "AAAAAA"))
                    .lineSpacing(4)
                    .padding(.bottom, 24)
            }
        }
    }
}

struct OurStoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OurStoryView()
        }
        .preferredColorScheme(.dark)
    }
}
