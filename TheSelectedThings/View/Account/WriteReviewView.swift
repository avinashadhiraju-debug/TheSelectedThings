//
//  WriteReviewView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 28/06/24.
//

import SwiftUI

struct WriteReviewView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var txtMessage = ""
    @State var rating = 5
    var onSubmit: ((ReviewModel) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Premium light gallery background (soft off-white/cream)
            Color(hex: "F8F8FA").ignoresSafeArea()
            
            // Soft pastel ambient glows for visual depth
            VStack {
                HStack {
                    Circle()
                        .fill(Color.primaryApp.opacity(0.06))
                        .frame(width: 250, height: 250)
                        .blur(radius: 80)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.secondaryprimaryApp.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .blur(radius: 90)
                }
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Editorial Subheader
                    VStack(spacing: 8) {
                        Text("FEEDBACK PORTAL")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(.primaryApp)
                            .tracking(3)
                        
                        Text("Share Your Thoughts")
                            .font(.customfont(.bold, fontSize: 26))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        Text("Evaluate the design integrity and raw materiality.")
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundColor(Color(hex: "666666"))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, .topInsets + 80)
                    .padding(.horizontal, 20)
                    
                    // 1. Interactive Star Rating Block
                    VStack(spacing: 12) {
                        Text("RATE THE ARCHITECTURE")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(Color(hex: "888888"))
                            .tracking(2.0)
                        
                        HStack(spacing: 14) {
                            ForEach(1...5, id: \.self) { index in
                                Button {
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                        rating = index
                                    }
                                } label: {
                                    Image(systemName: index <= rating ? "star.fill" : "star")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(index <= rating ? .primaryApp : Color(hex: "E2E2E7"))
                                        .frame(width: 34, height: 34)
                                        .scaleEffect(index == rating ? 1.2 : 1.0)
                                        .shadow(color: index <= rating ? .primaryApp.opacity(0.15) : Color.clear, radius: 6)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Text(ratingText)
                            .font(.customfont(.bold, fontSize: 12))
                            .foregroundColor(.primaryApp)
                            .tracking(1.0)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.black.opacity(0.04), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // 2. Premium Review Input Block
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SHARE YOUR STORY")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(Color(hex: "888888"))
                            .tracking(2.0)
                            .padding(.leading, 4)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $txtMessage)
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(Color(hex: "1C1C1E"))
                                .padding(14)
                                .frame(height: 180)
                                .scrollContentBackground(.hidden) // Hides default gray editor background
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.01), radius: 8, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                )
                            
                            if txtMessage.isEmpty {
                                Text("Detail your experience with the material quality, craftsman alignment, and geometric proportions of this piece...")
                                    .font(.customfont(.medium, fontSize: 13))
                                    .foregroundColor(Color(hex: "999999"))
                                    .lineSpacing(5)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 18)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // 3. Glowing Action Submit Button (Ebonized premium black button)
                    RoundButton(
                        title: "Publish Curation Review",
                        image: "checkmark.seal.fill",
                        isAdaptive: true,
                        useStyle2: true
                    ) {
                        let name = MainViewModel.shared.userObj.name.isEmpty ? (MainViewModel.shared.userObj.username.isEmpty ? "Anonymous Curator" : MainViewModel.shared.userObj.username) : MainViewModel.shared.userObj.name
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMM dd, yyyy"
                        let dateString = formatter.string(from: Date())
                        
                        let newReview = ReviewModel(
                            userName: name,
                            rating: rating,
                            date: dateString,
                            comment: txtMessage
                        )
                        
                        onSubmit?(newReview)
                        
                        withAnimation {
                            mode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(txtMessage.isEmpty)
                    .opacity(txtMessage.isEmpty ? 0.4 : 1.0)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }

        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .preferredColorScheme(.light)
    }
    
    // Custom rating feedback text
    private var ratingText: String {
        switch rating {
        case 1: return "UNSATISFACTORY FORM"
        case 2: return "IMPERFECT proportions"
        case 3: return "HONEST INTEGRITY"
        case 4: return "SUPERIOR CRAFT"
        case 5: return "ARCHITECTURAL MASTERPIECE"
        default: return "SELECT A RATING"
        }
    }
}

struct WriteReviewView_Previews: PreviewProvider {
    static var previews: some View {
        WriteReviewView()
            .preferredColorScheme(.light)
    }
}
