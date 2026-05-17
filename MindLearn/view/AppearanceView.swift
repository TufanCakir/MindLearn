//
//  AppearanceView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct AppearanceView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    var body: some View {
        ZStack {
            themeManager.backgroundColor
                .ignoresSafeArea()

            List {
                Section {
                    ForEach(themeManager.themes) { theme in
                        themeRow(theme)
                    }
                } header: {
                    Text(text.appearance.theme)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(text.appearance.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension AppearanceView {

    fileprivate func themeRow(_ theme: AppTheme) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                themeManager.selectTheme(theme)
            }
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            HStack(spacing: 14) {

                // MARK: - Icon Preview
                Image(systemName: theme.icon)
                    .font(.title2)
                    .frame(width: 36, height: 36)
                    .foregroundStyle(
                        theme.id == themeManager.selectedTheme.id
                            ? Color.accentColor
                            : Color.secondary
                    )
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )

                // MARK: - Title
                VStack(alignment: .leading, spacing: 2) {
                    Text(theme.name)
                        .font(.body)

                    Text(themeDescription(theme))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // MARK: - Checkmark
                if theme.id == themeManager.selectedTheme.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .transition(.scale)
                }
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

extension AppearanceView {

    fileprivate func themeDescription(_ theme: AppTheme) -> String {
        switch theme.preferredScheme {
        case "system":
            return text.appearance.system
        case "light":
            return text.appearance.light
        case "dark":
            return text.appearance.dark
        default:
            return text.appearance.standard
        }
    }
}

#Preview {
    PreviewRoot {
        AppearanceView()
    }
}
