//
//  AppShortcuts.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import AppIntents

// MARK: - App Shortcuts Provider

struct AppShortcuts: AppShortcutsProvider {

    static var shortcutTileColor: ShortcutTileColor { .purple }

    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {

        // 1️⃣ App öffnen
        AppShortcut(
            intent: OpenAppIntent(),
            phrases: [
                "Open ${applicationName}",
                "Start ${applicationName}",
                "Launch ${applicationName}",
                "Open ${applicationName}",
            ],
            shortTitle: "Open App",
            systemImageName: "sparkles"
        )

        // 2️⃣ JSON Validator öffnen
        AppShortcut(
            intent: OpenJSONValidatorIntent(),
            phrases: [
                "Open JSON validator in ${applicationName}",
                "Check JSON with ${applicationName}",
                "Validate JSON in ${applicationName}",
            ],
            shortTitle: "JSON Check",
            systemImageName: "curlybraces"
        )

        // 3️⃣ JSON Escape öffnen
        AppShortcut(
            intent: OpenJSONEscapeIntent(),
            phrases: [
                "Open JSON escape in ${applicationName}",
                "Escape JSON with ${applicationName}",
                "Convert JSON text in ${applicationName}",
            ],
            shortTitle: "JSON Escape",
            systemImageName: "ellipsis.curlybraces"
        )

        // 4️⃣ Favoriten öffnen
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

//
// MARK: - Base Protocol
//

protocol OpenTabIntent {
    static var tabIdentifier: String { get }
}

//
// MARK: - Open App
//

struct OpenAppIntent: AppIntent {

    static var title: LocalizedStringResource = "Open MindLearn"

    static var description =
        IntentDescription("Opens the MindLearn app.")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}

//
// MARK: - JSON Validator
//

struct OpenJSONValidatorIntent: AppIntent {

    static var title: LocalizedStringResource = "Open JSON Validator"

    static var description =
        IntentDescription("Opens the JSON validation tool.")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {

        await AppNavigation.openJSONValidator()

        return .result()
    }
}

//
// MARK: - JSON Escape
//

struct OpenJSONEscapeIntent: AppIntent {

    static var title: LocalizedStringResource = "Open JSON Escape"

    static var description =
        IntentDescription("Opens the JSON escape tool.")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {

        await AppNavigation.openJSONEscape()

        return .result()
    }
}

//
// MARK: - Favorites
//

struct OpenFavoritesIntent: AppIntent {

    static var title: LocalizedStringResource = "Open Favorites"

    static var description =
        IntentDescription("Shows your favorite learning topics.")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {

        await AppNavigation.openFavorites()

        return .result()
    }
}
