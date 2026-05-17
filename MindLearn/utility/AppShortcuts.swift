//
//  AppShortcuts.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor { .purple }

    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenAppIntent(),
            phrases: [
                "Open ${applicationName}",
                "Start ${applicationName}",
                "Launch ${applicationName}",
            ],
            shortTitle: "Open App",
            systemImageName: "sparkles"
        )

        AppShortcut(
            intent: OpenFavoritesIntent(),
            phrases: [
                "Open favorites in ${applicationName}",
                "Show my favorites in ${applicationName}",
            ],
            shortTitle: "Favorites",
            systemImageName: "star.fill"
        )
    }
}

// MARK: - Open App

struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Open MindLearn"
    static var description = IntentDescription("Opens the MindLearn app.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}

// MARK: - Favorites

struct OpenFavoritesIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Favorites"
    static var description = IntentDescription(
        "Shows your favorite learning topics."
    )
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        await AppNavigation.open(.favorites)
        return .result()
    }
}
