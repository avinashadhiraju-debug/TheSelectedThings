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
            Group {
                if mainVM.isUserLogin {
                    MainTabView()
                } else {
                    WelcomeView()
                }
            }
            .preferredColorScheme(mainVM.isDarkMode ? .dark : .light)
        }
    }
}
