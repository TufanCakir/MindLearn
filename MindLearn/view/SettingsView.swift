//
//  SettingsView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct SettingsView: View {

    // MARK: Storage

    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    @AppStorage("enhancedAccessibilityLabels")
    private var enhancedAccessibilityLabels = true

    @AppStorage("reduceAppMotion")
    private var reduceAppMotion = false

    @AppStorage("largeLearningCards")
    private var largeLearningCards = false

    // MARK: Localization

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    // MARK: Body

    var body: some View {

        ScrollView {

            VStack {

                VStack(spacing: 20) {

                    settingsCard {
                        languageSection
                    }

                    settingsCard {
                        appearanceSection
                    }

                    settingsCard {
                        accessibilitySection
                    }

                    settingsCard {
                        aboutSection
                    }
                }
                .padding(.vertical)
            }
        }

        .background(Color(.systemGroupedBackground))

        .navigationTitle(text.settings.title)

        .navigationBarTitleDisplayMode(.inline)

        .environment(
            \.locale,
            Locale(identifier: language)
        )
    }
}

// MARK: Settings Card

extension SettingsView {

    private func settingsCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {

        VStack(spacing: 0) {

            content()
        }

        .padding(.vertical, 8)

        .background(

            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .fill(
                Color(.secondarySystemGroupedBackground)
            )
        )

        .background(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .fill(Color(.secondarySystemGroupedBackground))
        )

        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            y: 4
        )

        .padding(.horizontal)
    }
}

//
// MARK: Language
//

extension SettingsView {

    private var languageSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            Label(
                text.settings.languageSection,
                systemImage: "globe"
            )
            .font(.headline)

            Picker(
                text.settings.languagePicker,
                selection: $language
            ) {

                Text(text.settings.languageDE)
                    .tag("de")

                Text(text.settings.languageEN)
                    .tag("en")
            }
            .pickerStyle(.segmented)

        }
        .padding()
    }
}

// MARK: Appearance

extension SettingsView {

    private var appearanceSection: some View {
        NavigationLink {
            AppearanceView()
        } label: {
            HStack {
                Label(text.settings.appearance, systemImage: "paintpalette")
                Spacer()

            }
            .padding()
        }
        .buttonStyle(.plain)
    }
}

// MARK: Accessibility

extension SettingsView {

    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(
                text.accessibility.settingsTitle,
                systemImage: "accessibility"
            )
            .font(.headline)

            accessibilityToggle(
                title: text.accessibility.enhancedLabels,
                hint: text.accessibility.enhancedLabelsHint,
                isOn: $enhancedAccessibilityLabels
            )

            accessibilityToggle(
                title: text.accessibility.reduceMotion,
                hint: text.accessibility.reduceMotionHint,
                isOn: $reduceAppMotion
            )

            accessibilityToggle(
                title: text.accessibility.largeCards,
                hint: text.accessibility.largeCardsHint,
                isOn: $largeLearningCards
            )
        }
        .padding()
    }

    private func accessibilityToggle(
        title: String,
        hint: String,
        isOn: Binding<Bool>
    ) -> some View {
        Toggle(isOn: isOn) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)

                Text(hint)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityHint(hint)
    }
}

//
// MARK: About
//

extension SettingsView {

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            // About App Section
            VStack(alignment: .leading, spacing: 0) {
                Text(text.settings.aboutSection)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 12)

                Divider()
                    .padding(.horizontal)

                NavigationLink {
                    InfoView()
                } label: {
                    HStack {
                        Label("MindLearn", systemImage: "book")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }

                Divider()
                    .padding(.horizontal)

                HStack {
                    Label(Bundle.main.appVersionString, systemImage: "number")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Divider()
                    .padding(.horizontal)

                HStack {
                    Label(text.settings.builtWith, systemImage: "applelogo")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer(minLength: 0)
                    .frame(height: 4)
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )

            // System Section
            VStack(alignment: .leading, spacing: 0) {
                Text(text.settings.system)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 12)

                Divider()
                    .padding(.horizontal)

                HStack {
                    Label(
                        "\(Bundle.systemName) \(Bundle.systemVersion)",
                        systemImage: "gear"
                    )
                    .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Divider()
                    .padding(.horizontal)

                HStack {
                    Label(Bundle.deviceModel, systemImage: "ipad.and.iphone")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Divider()
                    .padding(.horizontal)

                HStack {
                    Label(Bundle.compatibility, systemImage: "checkmark.shield")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer(minLength: 0)
                    .frame(height: 4)
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .padding()
    }
}

#Preview {

    PreviewRoot {

        NavigationStack {

            SettingsView()
        }
    }
}
