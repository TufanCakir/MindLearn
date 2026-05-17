//
//  SettingsView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    @AppStorage("enhancedAccessibilityLabels")
    private var enhancedAccessibilityLabels = true

    @AppStorage("reduceAppMotion")
    private var reduceAppMotion = false

    @AppStorage("largeLearningCards")
    private var largeLearningCards = false

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                languageSection
                appSection
                accessibilitySection
                aboutSection
                systemSection
            }
            .padding(.horizontal)
            .padding(.vertical, 18)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(text.settings.title)
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.locale, Locale(identifier: language))
    }
}

// MARK: - Sections

extension SettingsView {
    private var languageSection: some View {
        SettingsSection(
            title: text.settings.languageSection,
            systemImage: "globe"
        ) {
            Picker(text.settings.languagePicker, selection: $language) {
                Text(text.settings.languageDE).tag("de")
                Text(text.settings.languageEN).tag("en")
            }
            .pickerStyle(.segmented)
        }
    }

    private var appSection: some View {
        SettingsSection(
            title: text.settings.appearance,
            systemImage: "paintpalette"
        ) {
            NavigationLink {
                AppearanceView()
            } label: {
                SettingsRow(
                    title: text.settings.appearance,
                    systemImage: "paintpalette.fill",
                    value: nil,
                    showsChevron: true
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var accessibilitySection: some View {
        SettingsSection(
            title: text.accessibility.settingsTitle,
            systemImage: "accessibility"
        ) {
            VStack(spacing: 0) {
                accessibilityToggle(
                    title: text.accessibility.enhancedLabels,
                    hint: text.accessibility.enhancedLabelsHint,
                    isOn: $enhancedAccessibilityLabels
                )

                SettingsDivider()

                accessibilityToggle(
                    title: text.accessibility.reduceMotion,
                    hint: text.accessibility.reduceMotionHint,
                    isOn: $reduceAppMotion
                )

                SettingsDivider()

                accessibilityToggle(
                    title: text.accessibility.largeCards,
                    hint: text.accessibility.largeCardsHint,
                    isOn: $largeLearningCards
                )
            }
        }
    }

    private var aboutSection: some View {
        SettingsSection(
            title: text.settings.aboutSection,
            systemImage: "info.circle"
        ) {
            VStack(spacing: 0) {
                NavigationLink {
                    InfoView()
                } label: {
                    SettingsRow(
                        title: "MindLearn",
                        systemImage: "book.fill",
                        value: nil,
                        showsChevron: true
                    )
                }
                .buttonStyle(.plain)

                SettingsDivider()

                SettingsRow(
                    title: Bundle.main.appVersionString,
                    systemImage: "number",
                    value: nil
                )

                SettingsDivider()

                SettingsRow(
                    title: text.settings.builtWith,
                    systemImage: "applelogo",
                    value: nil
                )
            }
        }
    }

    private var systemSection: some View {
        SettingsSection(
            title: text.settings.system,
            systemImage: "gearshape"
        ) {
            VStack(spacing: 0) {
                SettingsRow(
                    title: Bundle.systemName,
                    systemImage: "gear",
                    value: Bundle.systemVersion
                )

                SettingsDivider()

                SettingsRow(
                    title: Bundle.deviceModel,
                    systemImage: "ipad.and.iphone",
                    value: nil
                )

                SettingsDivider()

                SettingsRow(
                    title: Bundle.compatibility,
                    systemImage: "checkmark.shield",
                    value: nil
                )
            }
        }
    }
}

// MARK: - Controls

extension SettingsView {
    private func accessibilityToggle(
        title: String,
        hint: String,
        isOn: Binding<Bool>
    ) -> some View {
        Toggle(isOn: isOn) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Text(hint)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 10)
        }
        .tint(.accentColor)
        .accessibilityHint(hint)
    }
}

// MARK: - Reusable Settings UI

private struct SettingsSection<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.primary)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
            )
        }
    }
}

private struct SettingsRow: View {
    let title: String
    let systemImage: String
    let value: String?
    var showsChevron = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.body)
                .foregroundStyle(Color.accentColor)
                .frame(width: 28, height: 28)
                .background(Color.accentColor.opacity(0.12))
                .clipShape(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                )

            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 12)

            if let value {
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(minHeight: 48)
        .contentShape(Rectangle())
    }
}

private struct SettingsDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 40)
    }
}

#Preview {
    PreviewRoot {
        NavigationStack {
            SettingsView()
        }
    }
}
