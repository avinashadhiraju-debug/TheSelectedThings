//
//  TheSelectedThingsApp.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 30/07/23.
//

import SwiftUI

@main
struct TheSelectedThingsApp: App {
    
    @StateObject var mainVM = MainViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if mainVM.isUserLogin {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    WelcomeView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.6), value: mainVM.isUserLogin)
            .preferredColorScheme(mainVM.isDarkMode ? .dark : .light)
        }
    }
}
