//
//  MyDetailsView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 15/08/23.
//

import SwiftUI
import CountryPicker

struct MyDetailsView: View {
    @StateObject var myVM = MyDetailsViewModel.shared

    private let fieldColor = Color(hex: "F3F3F3")
    private let labelColor = Color(hex: "AAAAAA")

    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Profile Details Card
                    VStack(alignment: .leading, spacing: 0) {
                        Text("PROFILE DETAILS")
                            .font(.customfont(.bold, fontSize: 11))
                            .foregroundColor(labelColor)
                            .tracking(1.5)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 10)

                        VStack(spacing: 22) {
                            LineTextField(
                                title: "Name",
                                placeholder: "Enter your name",
                                txt: $myVM.txtName,
                                textColor: fieldColor
                            )

                            // Mobile field
                            VStack(spacing: 4) {
                                Text("Mobile")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .foregroundColor(labelColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(spacing: 8) {
                                    Button { myVM.isShowPicker = true } label: {
                                        if let countryObj = myVM.countryObj {
                                            Text(countryObj.isoCode.getFlag())
                                                .font(.system(size: 26))
                                            Text("+\(countryObj.phoneCode)")
                                                .font(.customfont(.medium, fontSize: 16))
                                                .foregroundColor(fieldColor)
                                        }
                                    }

                                    TextField("Enter your mobile number", text: $myVM.txtMobile)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(fieldColor)
                                        .tint(fieldColor)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                }

                                Rectangle()
                                    .fill(Color.placeholder.opacity(0.5))
                                    .frame(height: 1)
                            }

                            LineTextField(
                                title: "Username",
                                placeholder: "Enter your username",
                                txt: $myVM.txtUsername,
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
                    RoundButton2(title: "Update Profile", image: "checkmark.circle.fill", isAdaptive: false) {
                        myVM.serviceCallUpdate()
                    }
                    .padding(.horizontal, 20)

                    // Change Password row
                    NavigationLink { ChangePasswordView() } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.primaryApp)
                                .font(.system(size: 16))
                                .frame(width: 28)

                            Text("Change Password")
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(fieldColor)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(labelColor)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
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
        .navigationTitle("My Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct MyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyDetailsView()
        }
        .preferredColorScheme(.dark)
    }
}
