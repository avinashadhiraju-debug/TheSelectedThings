//
//  ContactUsView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

struct ContactUsView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    @State private var inquiryType: String = "General Curation"
    
    // UI state controllers
    @State private var isShowingDropdown = false
    @State private var isSubmitting = false
    @State private var isSuccess = false
    @State private var copyHudMessage: String? = nil
    
    // Inquiry categories
    let inquiryCategories = ["General Curation", "Bespoke Spatial Design", "Artisanal Partnerships", "Technical Support"]
    
    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header Section
                    VStack(spacing: 8) {
                        Text("CONNECT")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(.primaryApp)
                            .tracking(3)
                        
                        Text("Contact Us")
                            .font(.customfont(.bold, fontSize: 32))
                            .foregroundColor(Color(hex: "F3F3F3"))
                        
                        Text("Speak with our curatorial board.")
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundColor(Color(hex: "AAAAAA"))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    // Form Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("SEND A MESSAGE")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(Color(hex: "AAAAAA"))
                            .tracking(2)
                            .padding(.horizontal, 4)
                        
                        // Custom Form Card
                        VStack(spacing: 16) {
                            
                            // Name Input
                            CustomInputField(placeholder: "Name", text: $name, icon: "person")
                            
                            // Email Input
                            CustomInputField(placeholder: "Email Address", text: $email, icon: "envelope", keyboardType: .emailAddress)
                            
                            // Inquiry Selector Row
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Inquiry Type")
                                    .font(.customfont(.bold, fontSize: 11))
                                    .foregroundColor(Color(hex: "888888"))
                                    .tracking(0.5)
                                    .padding(.leading, 4)
                                
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        isShowingDropdown.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text(inquiryType)
                                            .font(.customfont(.semibold, fontSize: 15))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.primaryApp)
                                            .rotationEffect(.degrees(isShowingDropdown ? 90 : 0))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.white.opacity(0.02))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                }
                                
                                // Floating dropdown overlay items
                                if isShowingDropdown {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(inquiryCategories, id: \.self) { category in
                                            Button {
                                                inquiryType = category
                                                withAnimation {
                                                    isShowingDropdown = false
                                                }
                                            } label: {
                                                HStack {
                                                    Text(category)
                                                        .font(.customfont(.medium, fontSize: 14))
                                                        .foregroundColor(inquiryType == category ? .primaryApp : Color(hex: "CCCCCC"))
                                                    
                                                    Spacer()
                                                    
                                                    if inquiryType == category {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 12, weight: .bold))
                                                            .foregroundColor(.primaryApp)
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(
                                                    inquiryType == category ? Color.primaryApp.opacity(0.05) : Color.clear
                                                )
                                            }
                                            
                                            if category != inquiryCategories.last {
                                                Divider()
                                                    .background(Color.white.opacity(0.05))
                                            }
                                        }
                                    }
                                    .background(Color(hex: "151515"))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            
                            // Message Input
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Your Message")
                                    .font(.customfont(.bold, fontSize: 11))
                                    .foregroundColor(Color(hex: "888888"))
                                    .tracking(0.5)
                                    .padding(.leading, 4)
                                
                                TextEditor(text: $message)
                                    .font(.customfont(.medium, fontSize: 14))
                                    .foregroundColor(Color(hex: "F3F3F3"))
                                    .padding(12)
                                    .frame(height: 120)
                                    .scrollContentBackground(.hidden) // Required in iOS 16 to hide default gray background
                                    .background(Color.white.opacity(0.02))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                            }
                            
                            // Submit Button
                            Button {
                                submitForm()
                            } label: {
                                HStack {
                                    if isSubmitting {
                                        ProgressView()
                                            .tint(.black)
                                    } else {
                                        Text("Transmit Message")
                                            .font(.customfont(.bold, fontSize: 15))
                                            .foregroundColor(Color(hex: "0D0D0D"))
                                        
                                        Image(systemName: "paperplane.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(hex: "0D0D0D"))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(
                                    name.isEmpty || email.isEmpty || message.isEmpty
                                        ? Color.primaryApp.opacity(0.3)
                                        : Color.primaryApp
                                )
                                .cornerRadius(16)
                                .shadow(color: name.isEmpty || email.isEmpty || message.isEmpty ? Color.clear : Color.primaryApp.opacity(0.3), radius: 8, y: 4)
                            }
                            .disabled(name.isEmpty || email.isEmpty || message.isEmpty || isSubmitting)
                            .padding(.top, 10)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.02))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Contact Info Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("SHOWROOM & DETAILS")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(Color(hex: "AAAAAA"))
                            .tracking(2)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 14) {
                            ContactDetailCard(
                                icon: "map.fill",
                                title: "Curation Showroom",
                                detail: "480 E. Marginal Way S, Seattle, WA",
                                copyAction: {
                                    copyToClipboard(text: "480 E. Marginal Way S, Seattle, WA", itemLabel: "Address")
                                }
                            )
                            
                            ContactDetailCard(
                                icon: "envelope.fill",
                                title: "Electronic Mail",
                                detail: "curators@selectedthings.com",
                                copyAction: {
                                    copyToClipboard(text: "curators@selectedthings.com", itemLabel: "Email")
                                }
                            )
                            
                            ContactDetailCard(
                                icon: "phone.fill",
                                title: "Telephone",
                                detail: "+1 (206) 555-8320",
                                copyAction: {
                                    copyToClipboard(text: "+1 (206) 555-8320", itemLabel: "Phone Number")
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // HUD Overlay for Clipboard Copy Notice
            if let hud = copyHudMessage {
                VStack {
                    Spacer()
                    Text(hud)
                        .font(.customfont(.bold, fontSize: 13))
                        .foregroundColor(Color(hex: "0D0D0D"))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.primaryApp)
                        .cornerRadius(24)
                        .shadow(color: Color.primaryApp.opacity(0.4), radius: 10, y: 5)
                        .padding(.bottom, 50)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Success Overlay screen
            if isSuccess {
                ZStack {
                    Color(hex: "0D0D0D").ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        // Curved success visual ring
                        ZStack {
                            Circle()
                                .stroke(Color.primaryApp.opacity(0.2), lineWidth: 4)
                                .frame(width: 100, height: 100)
                            
                            Circle()
                                .fill(Color.primaryApp.opacity(0.1))
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.primaryApp)
                        }
                        .scaleEffect(isSuccess ? 1.0 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: isSuccess)
                        
                        VStack(spacing: 12) {
                            Text("Message Transmitted")
                                .font(.customfont(.bold, fontSize: 22))
                                .foregroundColor(Color(hex: "F3F3F3"))
                            
                            Text("Your transmission has been verified. Our curatorial board will review and respond within 24 hours.")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundColor(Color(hex: "AAAAAA"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 30)
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                // Reset form and dismiss success state
                                name = ""
                                email = ""
                                message = ""
                                isSuccess = false
                            }
                        } label: {
                            Text("Return to Form")
                                .font(.customfont(.bold, fontSize: 15))
                                .foregroundColor(Color(hex: "F3F3F3"))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )
                        }
                        .padding(.top, 10)
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
    
    // Submits the form with fake networking logic
    private func submitForm() {
        withAnimation {
            isSubmitting = true
        }
        
        // Simulating highly responsive server call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                isSubmitting = false
                isSuccess = true
            }
        }
    }
    
    // Copies details to clipboard
    private func copyToClipboard(text: String, itemLabel: String) {
        UIPasteboard.general.string = text
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
            copyHudMessage = "\(itemLabel) Copied to Clipboard"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.35)) {
                if copyHudMessage == "\(itemLabel) Copied to Clipboard" {
                    copyHudMessage = nil
                }
            }
        }
    }
}

// Subcomponent: Custom input field with icon
struct CustomInputField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(.primaryApp.opacity(0.85))
                .frame(width: 20)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(Color(hex: "555555"))
                }
                
                TextField("", text: $text)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(Color(hex: "F3F3F3"))
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.none)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.02))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// Subcomponent: Information detail card with click-to-copy
struct ContactDetailCard: View {
    let icon: String
    let title: String
    let detail: String
    let copyAction: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.03))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primaryApp)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.customfont(.bold, fontSize: 10))
                    .foregroundColor(Color(hex: "888888"))
                    .tracking(1)
                
                Text(detail)
                    .font(.customfont(.semibold, fontSize: 14))
                    .foregroundColor(Color(hex: "F3F3F3"))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: copyAction) {
                Image(systemName: "doc.on.doc.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "888888"))
                    .padding(8)
                    .background(Color.white.opacity(0.02))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.01))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.03), lineWidth: 1)
        )
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactUsView()
        }
        .preferredColorScheme(.dark)
    }
}
