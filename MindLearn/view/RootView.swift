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

    private var text: AppLocalization {
        localization.text
    }

    private var practiceTitle: String {
        localization.language == "de" ? "Praxis" : "Practice"
    }

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            Tab(text.tabs.learn, systemImage: "book", value: .home) {
                AppNavigationContainer {
                    HomeView()
                }
            }

            Tab(practiceTitle, systemImage: "keyboard", value: .practice) {
                AppNavigationContainer {
                    PracticeView()
                }
            }

            Tab(text.tabs.help, systemImage: "lightbulb", value: .help) {
                AppNavigationContainer {
                    ConceptListView()
                }
            }

            Tab(
                text.tabs.favorites,
                systemImage: "star.fill",
                value: .favorites
            ) {
                AppNavigationContainer {
                    FavoritesView()
                }
            }

            Tab(value: .search, role: .search) {
                AppNavigationContainer {
                    GlobalSearchView()
                }
            }
        }
        .tabViewSearchActivation(.searchTabSelection)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

private struct AppNavigationContainer<Content: View>: View {
    @Environment(LocalizationStore.self) private var localization
    @State private var showsSettings = false

    @ViewBuilder let content: Content

    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showsSettings = true
                        } label: {
                            Image(systemName: "gear")
                        }
                        .accessibilityLabel(localization.text.tabs.settings)
                    }
                }
        }
        .sheet(isPresented: $showsSettings) {
            NavigationStack {
                SettingsView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(localization.text.common.done) {
                                showsSettings = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    PreviewRoot {
        RootView()
    }
}
