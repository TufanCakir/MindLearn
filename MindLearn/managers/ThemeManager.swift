//
//  ThemeManager.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

internal import Combine
import SwiftUI

@MainActor
final class ThemeManager: ObservableObject {

    // MARK: - Stored Data
    @Published private(set) var themes: [AppTheme]

    @AppStorage("selectedThemeID")
    private var selectedThemeID: String = "system"

    // MARK: - Init
    init() {
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
            ?? themes.first!
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

        return Color(hex: bg)
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

        return Color(hex: hex)
    }

    // MARK: - Public API
    func selectTheme(_ theme: AppTheme) {
        guard theme.id != selectedThemeID else { return }
        selectedThemeID = theme.id
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

// MARK: - Color + Hex Convenience
extension Color {
    /// Initialize a SwiftUI Color from a hex string.
    /// Supports the following formats (case-insensitive, with or without leading '#'):
    /// - RGB (e.g., "FFF")
    /// - RRGGBB (e.g., "FF00AA")
    /// - AARRGGBB (e.g., "CCFF00AA") where AA is alpha
    fileprivate init(hex: String) {
        // Sanitize input
        let cleaned =
            hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        let r: Double
        let g: Double
        let b: Double
        let a: Double
        switch cleaned.count {
        case 3:  // RGB, 4-bit each -> expand to 8-bit
            let rc = cleaned[cleaned.startIndex]
            let gc = cleaned[cleaned.index(cleaned.startIndex, offsetBy: 1)]
            let bc = cleaned[cleaned.index(cleaned.startIndex, offsetBy: 2)]
            let rs = String([rc, rc])
            let gs = String([gc, gc])
            let bs = String([bc, bc])
            let rv = UInt8(rs, radix: 16) ?? 0
            let gv = UInt8(gs, radix: 16) ?? 0
            let bv = UInt8(bs, radix: 16) ?? 0
            r = Double(rv) / 255.0
            g = Double(gv) / 255.0
            b = Double(bv) / 255.0
            a = 1.0
        case 6:  // RRGGBB
            let scanner = Scanner(string: cleaned)
            var value: UInt64 = 0
            scanner.scanHexInt64(&value)
            r = Double((value & 0xFF0000) >> 16) / 255.0
            g = Double((value & 0x00FF00) >> 8) / 255.0
            b = Double(value & 0x0000FF) / 255.0
            a = 1.0
        case 8:  // AARRGGBB
            let scanner = Scanner(string: cleaned)
            var value: UInt64 = 0
            scanner.scanHexInt64(&value)
            a = Double((value & 0xFF00_0000) >> 24) / 255.0
            r = Double((value & 0x00FF_0000) >> 16) / 255.0
            g = Double((value & 0x0000_FF00) >> 8) / 255.0
            b = Double(value & 0x0000_00FF) / 255.0
        default:
            // Fallback to system accent if input invalid
            self = .accentColor
            return
        }
        self = Color(red: r, green: g, blue: b, opacity: a)
    }
}
