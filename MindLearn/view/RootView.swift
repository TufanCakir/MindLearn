//
//  RootView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Tab(
                    tab.title(text),
                    systemImage: tab.systemImage,
                    value: tab
                ) {
                    NavigationStack {
                        tab.rootView
                    }
                }
            }
        }
    }
}

private extension AppTab {
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
