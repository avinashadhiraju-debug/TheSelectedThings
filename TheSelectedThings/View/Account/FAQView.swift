//
//  FAQView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

// Model representing FAQ Item
struct FAQItem: Identifiable {
    let id = UUID()
    let category: String
    let question: String
    let answer: String
}

struct FAQView: View {
    @State private var searchQuery: String = ""
    @State private var selectedCategory: String = "All"
    @State private var expandedItemId: UUID? = nil
    
    // Core categories
    let categories = ["All", "Curations", "Shipping", "Returns"]
    
    // Detailed Q&A Database
    let faqDatabase = [
        FAQItem(
            category: "Curations",
            question: "How are the items in the archive selected?",
            answer: "Our architectural and design boards scour the globe to vet independent craft workshops, ensuring each product stands out in terms of material authenticity, circular sustainability, and structural timelessness. We prioritize raw stones, ebonized timbers, and structural glass."
        ),
        FAQItem(
            category: "Curations",
            question: "Are the pieces in the lookbook available for purchase?",
            answer: "Yes, select pieces featured in our lookbooks are available for direct acquisition. Because these are sourced in extremely limited quantities from bespoke workshops, we manage transactions individually. Get in touch with our curators via the 'Contact Us' screen."
        ),
        FAQItem(
            category: "Curations",
            question: "Can I request custom-sized furniture commissions?",
            answer: "Absolutely. We maintain strong collaborations with master woodwork and metal workshops. You can coordinate bespoke sizing and finishes for any listed table or shelving systems by sending an inquiry through our Contact Us panel."
        ),
        FAQItem(
            category: "Shipping",
            question: "Do you ship internationally?",
            answer: "Yes, we ship globally using climate-neutral architectural cargo carriers. Every item is packed in structural wooden crates and fully insured. Customs fees and duties are calculated and managed at the dispatch stage."
        ),
        FAQItem(
            category: "Shipping",
            question: "What is your delivery timeframe for heavy objects?",
            answer: "Heavy items (such as concrete, stone, and ebonized ash furniture) require specialized packing and travel via white-glove courier services. Delivery generally takes 4 to 8 weeks depending on destination, with full tracking and scheduled arrival."
        ),
        FAQItem(
            category: "Returns",
            question: "What is the return policy for curated items?",
            answer: "Due to the unique, limited, or commissioned nature of our collection, we support a 14-day return window from receipt for regular products. Sourced, vintage, and custom-commissioned furniture are final sale and non-refundable."
        ),
        FAQItem(
            category: "Returns",
            question: "How is a return shipment handled?",
            answer: "If you need to return a qualified item, please contact our support. We do not require you to drop it off; instead, our white-glove logistic agents will schedule a home pickup to ensure the item is transported back safely."
        )
    ]
    
    // Filtered FAQ list based on category and search query
    var filteredFAQs: [FAQItem] {
        faqDatabase.filter { item in
            let matchesCategory = selectedCategory == "All" || item.category == selectedCategory
            let matchesSearch = searchQuery.isEmpty ||
                item.question.lowercased().contains(searchQuery.lowercased()) ||
                item.answer.lowercased().contains(searchQuery.lowercased())
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header block
                VStack(spacing: 8) {
                    Text("ARCHIVE HELP")
                        .font(.customfont(.bold, fontSize: 11))
                        .foregroundColor(.primaryApp)
                        .tracking(3)
                    
                    Text("FAQ")
                        .font(.customfont(.bold, fontSize: 32))
                        .foregroundColor(Color(hex: "F3F3F3"))
                    
                    Text("Common questions regarding shipping and curations.")
                        .font(.customfont(.medium, fontSize: 13))
                        .foregroundColor(Color(hex: "AAAAAA"))
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // 1. Sleek Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "888888"))
                    
                    ZStack(alignment: .leading) {
                        if searchQuery.isEmpty {
                            Text("Search questions or answers...")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(Color(hex: "555555"))
                        }
                        
                        TextField("", text: $searchQuery)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(Color(hex: "F3F3F3"))
                            .textInputAutocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    if !searchQuery.isEmpty {
                        Button {
                            searchQuery = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "888888"))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.02))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // 2. Category Selector Chips (Horizontal Scroll)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { cat in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    selectedCategory = cat
                                    expandedItemId = nil // Close any open accordion when switching categories
                                }
                            } label: {
                                Text(cat)
                                    .font(.customfont(.bold, fontSize: 13))
                                    .foregroundColor(selectedCategory == cat ? Color(hex: "0D0D0D") : Color(hex: "F3F3F3"))
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedCategory == cat
                                            ? Color.primaryApp
                                            : Color.white.opacity(0.02)
                                    )
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                selectedCategory == cat ? Color.primaryApp : Color.white.opacity(0.08),
                                                lineWidth: 1
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                
                // 3. Expandable Accordion List
                ScrollView(showsIndicators: false) {
                    if filteredFAQs.isEmpty {
                        VStack(spacing: 14) {
                            Image(systemName: "questionmark.bubble")
                                .font(.system(size: 38))
                                .foregroundColor(Color(hex: "555555"))
                                .padding(.top, 40)
                            
                            Text("No questions match your query.")
                                .font(.customfont(.medium, fontSize: 15))
                                .foregroundColor(Color(hex: "AAAAAA"))
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: 14) {
                            ForEach(filteredFAQs) { item in
                                let isExpanded = expandedItemId == item.id
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Button {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                                            if isExpanded {
                                                expandedItemId = nil
                                            } else {
                                                expandedItemId = item.id
                                            }
                                        }
                                    } label: {
                                        HStack(alignment: .top, spacing: 12) {
                                            Text(item.question)
                                                .font(.customfont(.bold, fontSize: 15))
                                                .foregroundColor(Color(hex: "F3F3F3"))
                                                .multilineTextAlignment(.leading)
                                                .lineSpacing(4)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.primaryApp)
                                                .rotationEffect(.degrees(isExpanded ? 90 : 0))
                                                .padding(.top, 2)
                                        }
                                        .padding(18)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if isExpanded {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Divider()
                                                .background(Color.white.opacity(0.08))
                                                .padding(.horizontal, 18)
                                            
                                            Text(item.answer)
                                                .font(.customfont(.medium, fontSize: 13.5))
                                                .foregroundColor(Color(hex: "AAAAAA"))
                                                .lineSpacing(6)
                                                .padding(18)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .background(Color.white.opacity(0.01))
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.white.opacity(0.02))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            isExpanded
                                                ? Color.primaryApp.opacity(0.3)
                                                : Color.white.opacity(0.06),
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FAQView()
        }
        .preferredColorScheme(.dark)
    }
}
