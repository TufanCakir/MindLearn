//
//  AccountView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct AccountView: View {

    // MARK: Environment

    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: Storage

    @AppStorage("username") private var username = ""

    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    // MARK: Localization

    private var text: AccountLocalization {
        Bundle.main.loadAccountLocalization(language: language)
    }

    // MARK: Initials

    private var initials: String {

        let letters =
            username
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)

        return letters.isEmpty
            ? "?"
            : letters.map { String($0).uppercased() }.joined()
    }

    // MARK: Body

    var body: some View {

        ScrollView {

            VStack {

                profileHeader

                settingsCard {

                    languageSection

                    aboutSection

                }

            }
            .padding()
        }

        .background(Color(.systemGroupedBackground))
        .shadow(
            color: .black.opacity(0.06),
            radius: 12,
            y: 6
        )

        .navigationTitle(text.title)

        .navigationBarTitleDisplayMode(.inline)

        .environment(
            \.locale,
            Locale(identifier: language)
        )
    }
}

//
// MARK: Profile Hero ⭐⭐⭐⭐⭐
//

extension AccountView {

    private var profileHeader: some View {

        VStack(spacing: 16) {

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            .accentColor,
                            .accentColor.opacity(0.65),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 86, height: 86)

                .overlay {

                    Text(initials)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                }

                .shadow(radius: 8, y: 4)

            VStack(spacing: 6) {

                TextField(
                    text.profileNamePlaceholder,
                    text: $username
                )
                .textFieldStyle(.roundedBorder)

                Text(text.profileLocal)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

        }

        .frame(maxWidth: .infinity)

        .padding(22)

        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )

        .padding(.horizontal)
    }
}

//
// MARK: Settings Card ⭐
//

extension AccountView {

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

extension AccountView {

    private var languageSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Label(
                text.languageSection,
                systemImage: "globe"
            )
            .font(.headline)

            Picker(
                text.languagePicker,
                selection: $language
            ) {

                Text(text.languageDE)
                    .tag("de")

                Text(text.languageEN)
                    .tag("en")
            }
            .pickerStyle(.segmented)

        }
        .padding()
    }
}

//
// MARK: About
//

extension AccountView {

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            // About App Section
            VStack(alignment: .leading, spacing: 0) {
                Text(text.aboutSection)
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
                    Label(text.builtWith, systemImage: "applelogo")
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
                Text("System")
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

            AccountView()
        }
    }
}
