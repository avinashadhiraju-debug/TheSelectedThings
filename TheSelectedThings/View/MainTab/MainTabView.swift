//
//  MainTabView.swift
//  TheSelectedThings
//
//  crated by Avinash Adhiraju.
//

import SwiftUI

// Represents each tab in the app's main navigation
enum AppTab: Int {
    case discover = 0
    case explore  = 1
    case wishlist = 2
    case profile  = 3

    var title: String {
        switch self {
        case .discover: return "Home"
        case .explore:  return "Explore"
        case .wishlist: return "Wishlist"
        case .profile:  return "Profile"
        }
    }

    var imageName: String {
        switch self {
        case .discover: return "home"
        case .explore:  return "search"
        case .wishlist: return "favorate"
        case .profile:  return "account"
        }
    }
}

struct MainTabView: View {
    @StateObject private var homeVM = HomeViewModel.shared

    init() {
        // Prevent tab bar from becoming transparent when scroll content underlaps it
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        // Explicit tab declarations let SwiftUI build a concrete TupleView at
        // compile time, which diffs faster than a generic ForEach closure.
        // Each tab has its own NavigationView so navigation state is isolated
        // between tabs (e.g. pushing from Explore doesn't affect Discover).
        TabView(selection: $homeVM.selectTab) {
            NavigationView { HomeView() }
                .tabItem { tabLabel(for: .discover) }
                .tag(AppTab.discover.rawValue)

            NavigationView { ExploreView() }
                .tabItem { tabLabel(for: .explore) }
                .tag(AppTab.explore.rawValue)

            NavigationView { FavouriteView() }
                .tabItem { tabLabel(for: .wishlist) }
                .tag(AppTab.wishlist.rawValue)

            NavigationView { AccountView() }
                .tabItem { tabLabel(for: .profile) }
                .tag(AppTab.profile.rawValue)
        }
        .accentColor(.primaryApp)
    }

    @ViewBuilder
    private func tabLabel(for tab: AppTab) -> some View {
        Image.resizedTabImage(named: tab.imageName, isSelected: homeVM.selectTab == tab.rawValue)
        Text(tab.title)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
