//
//  MainTabView.swift
//  TheSelectedThings
//
//  Created by Antigravity on 26/05/26.
//

import SwiftUI

enum AppTab: Int, CaseIterable {
    case discover = 0
    case explore = 1
    case wishlist = 2
    case profile = 3
    
    var title: String {
        switch self {
        case .discover: return "Discover"
        case .explore: return "Explore"
        case .wishlist: return "Wishlist"
        case .profile: return "Profile"
        }
    }
    
    var imageName: String {
        switch self {
        case .discover: return "home"
        case .explore: return "search"
        case .wishlist: return "favorate"
        case .profile: return "account"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .discover:
            HomeView()
        case .explore:
            ExploreView()
        case .wishlist:
            FavouriteView()
        case .profile:
            AccountView()
        }
    }
}

struct MainTabView: View {
    @StateObject var homeVM = HomeViewModel.shared
    
    init() {
        // Set standard tab bar styling
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView(selection: $homeVM.selectTab) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                tab.destinationView
                    .tabItem {
                        Image.resizedTabImage(named: tab.imageName, isSelected: homeVM.selectTab == tab.rawValue)
                        Text(tab.title)
                    }
                    .tag(tab.rawValue)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .accentColor(.primaryText)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainTabView()
        }
    }
}
