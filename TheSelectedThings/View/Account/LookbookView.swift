//
//  LookbookView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

// Model representing a Lookbook Room
struct LookbookRoom: Identifiable {
    let id: String
    let name: String
    let era: String
    let description: String
    let colors: [String] // Hex codes representing the color palette
    let colorNames: [String]
    let materials: [String]
    let dimensions: String
    let primaryAccent: Color
}

struct LookbookView: View {
    // Elegant sample data representing design-forward spaces
    @State private var rooms = [
        LookbookRoom(
            id: "1",
            name: "The Japandi Atelier",
            era: "Contemporary Organic",
            description: "A perfect convergence of Scandinavian functionality and Japanese rustic minimalism. Built with low heights to honor floor-centric living, drawing focus to raw materials and natural shadows.",
            colors: ["EFEBE4", "D6CFC7", "3A3E38", "121212"],
            colorNames: ["Warm Oatmeal", "Pale Ash", "Moss Charcoal", "Raw Ebonized"],
            materials: ["Textured Linen", "Brushed Travertine", "Raw White Ash", "Washi Paper"],
            dimensions: "18.5’ x 22.0’ x 9.5’",
            primaryAccent: Color(hex: "D6CFC7")
        ),
        LookbookRoom(
            id: "2",
            name: "The Brutalist Study",
            era: "Mid-Century Structuralist",
            description: "An homage to raw geometry, heavy shadows, and unadorned structural honesty. Dominated by linear cold surfaces contrasted beautifully by warm, organic waxed leather.",
            colors: ["7D8082", "2E3033", "806848", "080808"],
            colorNames: ["Cold Concrete", "Iron Ore", "Cast Bronze", "Deep Obsidian"],
            materials: ["Cast Concrete", "Hammered Carbon Steel", "Waxed Saddle Leather", "Ebonized Walnut"],
            dimensions: "14.0’ x 16.5’ x 11.0’",
            primaryAccent: Color(hex: "806848")
        ),
        LookbookRoom(
            id: "3",
            name: "The Bauhaus Lounge",
            era: "Modern Functionalist (1925)",
            description: "Focuses on tubular steel innovation, primary color highlights, and nested spatial geometries. Represents the absolute distillation of form following function, with airy, transparent volumes.",
            colors: ["CD5C5C", "E2E8F0", "2D3748", "1C1C1E"],
            colorNames: ["Bauhaus Red", "Chrome Steel", "Matte Charcoal", "Base White"],
            materials: ["Tubular Chrome Steel", "Molded Plywood", "Knitted Primary Wool", "Opal Glass"],
            dimensions: "20.0’ x 24.5’ x 10.0’",
            primaryAccent: Color(hex: "CD5C5C")
        )
    ]
    
    // Tracks the expanded room card
    @State private var expandedRoomId: String? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Header editorial block
                    VStack(spacing: 8) {
                        Text("OPEN ARCHIVE")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(.primaryApp)
                            .tracking(3)
                        
                        Text("Curated Lookbook")
                            .font(.customfont(.bold, fontSize: 30))
                            .foregroundColor(Color(hex: "F3F3F3"))
                        
                        Text("Volume IV / Spatial Geometries")
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundColor(Color(hex: "AAAAAA"))
                            .italic()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    // Room Card List
                    ForEach(rooms) { room in
                        let isExpanded = expandedRoomId == room.id
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            // 1. Room Hero Component (Styled canvas graphic representing the room)
                            ZStack {
                                // Dynamic background gradient representing room colors
                                LinearGradient(
                                    colors: [
                                        Color(hex: room.colors.first ?? "333333").opacity(0.85),
                                        Color(hex: room.colors.indices.contains(2) ? room.colors[2] : "111111").opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(height: 180)
                                
                                // Decorative geometric canvas shapes representing the room's character
                                GeometryReader { geo in
                                    ZStack {
                                        // Accent Circle
                                        Circle()
                                            .fill(room.primaryAccent.opacity(0.45))
                                            .frame(width: 130, height: 130)
                                            .offset(x: geo.size.width * 0.1, y: 30)
                                            .blur(radius: 10)
                                        
                                        // Structural block
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                                            .frame(width: 140, height: 100)
                                            .offset(x: geo.size.width * 0.55, y: 40)
                                            .rotationEffect(.degrees(15))
                                        
                                        // Floating sphere
                                        Circle()
                                            .fill(
                                                RadialGradient(
                                                    colors: [Color.white.opacity(0.9), Color.white.opacity(0.1)],
                                                    center: .topLeading,
                                                    startRadius: 2,
                                                    endRadius: 30
                                                )
                                            )
                                            .frame(width: 40, height: 40)
                                            .offset(x: geo.size.width * 0.45, y: 90)
                                            .shadow(color: Color.black.opacity(0.4), radius: 10, y: 8)
                                    }
                                }
                                
                                // Era Tag
                                VStack {
                                    HStack {
                                        Text(room.era.uppercased())
                                            .font(.customfont(.bold, fontSize: 9))
                                            .foregroundColor(Color(hex: "0D0D0D"))
                                            .tracking(1.5)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.white)
                                            .cornerRadius(6)
                                            .padding(16)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                
                                // Title overlay inside image card
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text(room.name)
                                            .font(.customfont(.bold, fontSize: 22))
                                            .foregroundColor(Color.white)
                                            .shadow(color: Color.black.opacity(0.8), radius: 8, x: 0, y: 4)
                                            .padding(20)
                                        Spacer()
                                    }
                                }
                            }
                            .clipShape(RoundedCorner(radius: 24, corers: [.topLeft, .topRight]))
                            
                            // 2. Info Description Section
                            VStack(alignment: .leading, spacing: 14) {
                                Text(room.description)
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(Color(hex: "CCCCCC"))
                                    .lineSpacing(6)
                                
                                // Expanded Details
                                if isExpanded {
                                    VStack(alignment: .leading, spacing: 18) {
                                        Divider()
                                            .background(Color.white.opacity(0.1))
                                        
                                        // Color Swatches
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("CURATED COLOR PALETTE")
                                                .font(.customfont(.bold, fontSize: 10))
                                                .foregroundColor(Color(hex: "AAAAAA"))
                                                .tracking(1.5)
                                            
                                            HStack(spacing: 12) {
                                                ForEach(0..<room.colors.count, id: \.self) { index in
                                                    VStack(spacing: 6) {
                                                        Circle()
                                                            .fill(Color(hex: room.colors[index]))
                                                            .frame(width: 36, height: 36)
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                                            )
                                                            .shadow(color: Color.black.opacity(0.2), radius: 4, y: 2)
                                                        
                                                        Text(room.colorNames[index])
                                                            .font(.customfont(.medium, fontSize: 9))
                                                            .foregroundColor(Color(hex: "888888"))
                                                            .lineLimit(1)
                                                            .frame(width: 55)
                                                    }
                                                }
                                            }
                                        }
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                        
                                        // Materials & Dimensions
                                        HStack(alignment: .top, spacing: 20) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("AUTHENTIC MATERIALS")
                                                    .font(.customfont(.bold, fontSize: 10))
                                                    .foregroundColor(Color(hex: "AAAAAA"))
                                                    .tracking(1.5)
                                                
                                                ForEach(room.materials, id: \.self) { mat in
                                                    HStack(spacing: 6) {
                                                        Circle()
                                                            .fill(Color.primaryApp)
                                                            .frame(width: 4, height: 4)
                                                        Text(mat)
                                                            .font(.customfont(.medium, fontSize: 13))
                                                            .foregroundColor(Color(hex: "CCCCCC"))
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("VOLUME DIMENSIONS")
                                                    .font(.customfont(.bold, fontSize: 10))
                                                    .foregroundColor(Color(hex: "AAAAAA"))
                                                    .tracking(1.5)
                                                
                                                Text(room.dimensions)
                                                    .font(.customfont(.semibold, fontSize: 13))
                                                    .foregroundColor(Color(hex: "F3F3F3"))
                                                
                                                Text("Optimized for sound acoustics and light bounce.")
                                                    .font(.customfont(.medium, fontSize: 11))
                                                    .foregroundColor(Color(hex: "888888"))
                                                    .lineSpacing(3)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                    }
                                }
                                
                                // 3. Expand / Collapse Trigger Row
                                Button {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                                        if isExpanded {
                                            expandedRoomId = nil
                                        } else {
                                            expandedRoomId = room.id
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(isExpanded ? "Collapse Details" : "Explore Spatial Details")
                                            .font(.customfont(.bold, fontSize: 13))
                                            .foregroundColor(.primaryApp)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.primaryApp.opacity(0.85))
                                            .rotationEffect(.degrees(isExpanded ? 0 : 180))
                                    }
                                    .padding(.top, 6)
                                }
                            }
                            .padding(20)
                            .background(Color.white.opacity(0.01))
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.02))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    LinearGradient(
                                        colors: isExpanded
                                            ? [Color.primaryApp.opacity(0.4), Color.clear, Color.secondaryprimaryApp.opacity(0.4)]
                                            : [Color.white.opacity(0.08), Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: isExpanded ? 1.5 : 1
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Lookbook")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct LookbookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LookbookView()
        }
        .preferredColorScheme(.dark)
    }
}
