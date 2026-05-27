//
//  ChangePasswordView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 16/08/23.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var myVM = MyDetailsViewModel.shared

    private let fieldColor = Color(hex: "F3F3F3")
    private let labelColor = Color(hex: "AAAAAA")

    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Security Card
                    VStack(alignment: .leading, spacing: 0) {
                        Text("SECURITY")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(labelColor)
                            .tracking(1.5)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 10)

                        VStack(spacing: 22) {
                            LineSecureField(
                                title: "Current Password",
                                placeholder: "Enter your current password",
                                txt: $myVM.txtCurrentPassword,
                                isShowPassword: $myVM.isCurrentPassword,
                                textColor: fieldColor
                            )

                            LineSecureField(
                                title: "New Password",
                                placeholder: "Enter your new password",
                                txt: $myVM.txtNewPassword,
                                isShowPassword: $myVM.isNewPassword,
                                textColor: fieldColor
                            )

                            LineSecureField(
                                title: "Confirm Password",
                                placeholder: "Enter your confirm password",
                                txt: $myVM.txtConfirmPassword,
                                isShowPassword: $myVM.isConfirmPassword,
                                textColor: fieldColor
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
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

                    // Update button
                    RoundButton2(title: "Update Password", image: "lock.fill", isAdaptive: false) {
                        myVM.serviceCallChangePassword()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 15)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $myVM.isShowPicker) {
            CountryPickerUI(country: $myVM.countryObj)
        }
        .alert(isPresented: $myVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(myVM.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePasswordView()
        }
        .preferredColorScheme(.dark)
    }
}
