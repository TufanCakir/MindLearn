//
//  RootView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct RootView: View {

    @State private var selectedTab: Tab = .home
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    enum Tab: CaseIterable, Hashable {
        case home
        case help
        case favorites
        case settings

        func title(_ text: AppLocalization) -> String {
            switch self {
            case .home: text.tabs.learn
            case .help: text.tabs.help
            case .favorites: text.tabs.favorites
            case .settings: text.tabs.settings
            }
        }

        var systemImage: String {
            switch self {
            case .home: "book"
            case .help: "lightbulb"
            case .favorites: "star.fill"
            case .settings: "gear"
            }
        }

        init?(_ destination: AppNavigation.Destination) {
            switch destination {
            case .favorites: self = .favorites
            }
        }

        @ViewBuilder
        var rootView: some View {
            switch self {
            case .home: HomeView()
            case .help: ConceptListView()
            case .favorites: FavoritesView()
            case .settings: SettingsView()
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                NavigationStack {
                    tab.rootView
                }
                .tabItem {
                    Label(tab.title(text), systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .openAppDestination
            )
        ) { notification in
            guard
                let destination = notification.object
                    as? AppNavigation.Destination,
                let tab = Tab(destination)
            else { return }

            open(tab)
        }
    }

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
