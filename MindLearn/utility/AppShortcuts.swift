//
//  AppShortcuts.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import AppIntents

// MARK: - App Shortcuts

struct AppShortcuts: AppShortcutsProvider {

    static var shortcutTileColor: ShortcutTileColor { .purple }

    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenIntent(),
            phrases: [
                "Open ${applicationName}",
                "Start ${applicationName}",
                "Launch ${applicationName}",
            ],
            shortTitle: "Open MindLearn",
            systemImageName: "sparkles"
        )
    }
}

// MARK: - Open App Intent

struct OpenIntent: AppIntent {

    static var title: LocalizedStringResource = "Open MindLearn"
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}
