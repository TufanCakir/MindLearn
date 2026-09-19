//
//  ThemeManager.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class ThemeManager {

    private(set) var themes: [AppTheme]

    private var selectedThemeID: String
    private let defaults: UserDefaults

    // MARK: - Init
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.selectedThemeID = defaults.string(forKey: "selectedThemeID") ?? "system"
        let loadedThemes = Bundle.main.loadThemes()
        self.themes =
            loadedThemes.isEmpty
            ? [ThemeManager.fallbackTheme]
            : loadedThemes
    }

    // MARK: - Selected Theme
    var selectedTheme: AppTheme {
        themes.first { $0.id == selectedThemeID }
            ?? themes.first { $0.id == "system" }
            ?? ThemeManager.fallbackTheme
    }

    // MARK: - Background Color
    var backgroundColor: Color {
        guard
            let bg = selectedTheme.backgroundColor?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !bg.isEmpty,
            selectedTheme.id != "system"
        else {
            return Color(.systemBackground)
        }

        return Color(hex: bg) ?? Color(.systemBackground)
    }

    // MARK: - Color Scheme
    var colorScheme: ColorScheme? {
        switch selectedTheme.preferredScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil  // system
        }
    }

    // MARK: - Accent Color
    var accentColor: Color {
        let hex = selectedTheme.accentColor
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            !hex.isEmpty,
            selectedTheme.id != "system"
        else {
            return .accentColor
        }

        return Color(hex: hex) ?? .accentColor
    }

    // MARK: - Public API
    func selectTheme(_ theme: AppTheme) {
        guard theme.id != selectedThemeID else { return }
        selectedThemeID = theme.id
        defaults.set(theme.id, forKey: "selectedThemeID")
    }
}

extension ThemeManager {

    fileprivate static let fallbackTheme = AppTheme(
        id: "system",
        name: "System",
        icon: "circle.lefthalf.filled",
        accentColor: "",
        preferredScheme: "system",
        backgroundColor: nil
    )
}
