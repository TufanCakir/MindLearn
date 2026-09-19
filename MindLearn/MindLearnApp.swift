//
//  MindLearnApp.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

@main
struct MindLearnApp: App {
    @State private var themeManager = ThemeManager()
    @State private var router = AppRouter.shared
    @State private var localization: LocalizationStore?
    private let localizationError: Error?
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    init() {
        do {
            _localization = State(initialValue: try LocalizationStore())
            localizationError = nil
        } catch {
            _localization = State(initialValue: nil)
            localizationError = error
        }
    }

    var body: some Scene {
        WindowGroup {
            if let localization {
                AppContainerView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environment(themeManager)
                    .environment(router)
                    .environment(localization)
                    .preferredColorScheme(themeManager.colorScheme)
                    .tint(themeManager.accentColor)
                    .environment(\.locale, localization.locale)
            } else {
                LocalizationFailureView(error: localizationError)
            }
        }
        .modelContainer(for: [LearningProgress.self, Favorite.self])
    }
}

private struct LocalizationFailureView: View {
    let error: Error?

    var body: some View {
        ContentUnavailableView {
            Label("Localization Error", systemImage: "exclamationmark.triangle")
        } description: {
            Text(error?.localizedDescription ?? "The app texts could not be loaded.")
        }
    }
}

struct AppContainerView: View {
    @Binding var hasSeenOnboarding: Bool
    @Environment(\.modelContext) private var modelContext
    @AppStorage("didMigrateFavoritesToSwiftData")
    private var didMigrateFavorites = false

    var body: some View {
        ZStack {
            if hasSeenOnboarding {
                RootView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(
                                with: .scale(scale: 0.98)
                            ),
                            removal: .opacity
                        )
                    )
            } else {
                OnboardingView(onFinish: completeOnboarding)
                    .transition(.opacity)
            }
        }
        .animation(
            .spring(response: 0.5, dampingFraction: 0.88, blendDuration: 0.2),
            value: hasSeenOnboarding
        )
        .task {
            migrateLegacyFavoritesIfNeeded()
        }
    }

    private func completeOnboarding() {
        withAnimation {
            hasSeenOnboarding = true
        }
    }

    private func migrateLegacyFavoritesIfNeeded() {
        guard !didMigrateFavorites else { return }

        do {
            try FavoritesRepository.migrateLegacyFavorites(
                from: .standard,
                into: modelContext
            )
            didMigrateFavorites = true
        } catch {
            assertionFailure("Favorite migration failed: \(error)")
        }
    }
}
