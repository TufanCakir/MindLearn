//
//  AppearanceView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct AppearanceView: View {

    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
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
        .toolbarTitleDisplayMode(.inline)
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
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // MARK: - Checkmark
                if theme.id == themeManager.selectedTheme.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.tint)
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
