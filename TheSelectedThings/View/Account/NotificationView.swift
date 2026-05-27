//
//  NotificationView.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 15/08/23.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var notiVM = NotificationViewModel.shared

    var body: some View {
        ZStack {
            Color(hex: "0D0D0D").ignoresSafeArea()

            if notiVM.listArr.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 44))
                        .foregroundColor(Color(hex: "AAAAAA"))
                    Text("No notifications yet")
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(Color(hex: "AAAAAA"))
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(notiVM.listArr, id: \.id) { nObj in
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(nObj.isRead == 0 ? Color.primaryApp : Color.clear)
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 5)

                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(alignment: .top) {
                                        Text(nObj.title)
                                            .font(.customfont(.bold, fontSize: 14))
                                            .foregroundColor(Color(hex: "F3F3F3"))
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Text(nObj.createdDate.displayDate(format: "MMM d"))
                                            .font(.customfont(.regular, fontSize: 11))
                                            .foregroundColor(Color(hex: "AAAAAA"))
                                    }

                                    Text(nObj.message)
                                        .font(.customfont(.medium, fontSize: 13))
                                        .foregroundColor(Color(hex: "AAAAAA"))
                                        .lineSpacing(5)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(nObj.isRead == 0 ? Color.primaryApp.opacity(0.07) : Color.white.opacity(0.02))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        LinearGradient(
                                            colors: nObj.isRead == 0
                                                ? [Color.primaryApp.opacity(0.50), Color.clear]
                                                : [Color.white.opacity(0.07), Color.clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .padding(.bottom, 20)
                }
            }
        }
        .alert(isPresented: $notiVM.showError) {
            Alert(title: Text(Globs.AppName), message: Text(notiVM.errorMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    notiVM.serviceCallReadAll()
                } label: {
                    Text("Read All")
                        .font(.customfont(.bold, fontSize: 14))
                        .foregroundColor(.primaryApp)
                }
            }
        }
        .toolbarBackground(Color(hex: "0D0D0D"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationView()
        }
        .preferredColorScheme(.dark)
    }
}
