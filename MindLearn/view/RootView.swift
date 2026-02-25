//
//  RootView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct RootView: View {

    @State private var selectedTab: Tab = .home

    enum Tab: Hashable {
        case home
        case favorites
        case escape
        case validator
        case account
    }

    var body: some View {

        TabView(selection: $selectedTab) {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Learn", systemImage: "book")
            }
            .tag(Tab.home)

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favoriten", systemImage: "star.fill")
            }
            .tag(Tab.favorites)

            NavigationStack {
                JSONEscapeStudioView()
            }
            .tabItem {
                Label("JSON Escape", systemImage: "ellipsis.curlybraces")
            }
            .tag(Tab.escape)

            NavigationStack {
                JSONValidatorView()
            }
            .tabItem {
                Label("JSON Check", systemImage: "curlybraces")
            }
            .tag(Tab.validator)

            NavigationStack {
                AccountView()
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle")
            }
            .tag(Tab.account)
        }

        // MARK: Notifications

        .onReceive(
            NotificationCenter.default.publisher(
                for: .openJSONValidator
            )
        ) { _ in
            open(.validator)
        }

        .onReceive(
            NotificationCenter.default.publisher(
                for: .openJSONEscape
            )
        ) { _ in
            open(.escape)
        }

        .onReceive(
            NotificationCenter.default.publisher(
                for: .openFavorites
            )
        ) { _ in
            open(.favorites)
        }
    }

    // ⭐ HIER rein !!

    private func open(_ tab: Tab) {

        withAnimation(
            .spring(
                response: 0.45,
                dampingFraction: 0.85
            )
        ) {
            selectedTab = tab
        }
    }
}
