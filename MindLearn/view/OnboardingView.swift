//
//  OnboardingView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct OnboardingView: View {

    var onFinish: () -> Void

    @State private var page = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("reduceAppMotion")
    private var reduceAppMotion = false
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    private var shouldReduceMotion: Bool {
        reduceMotion || reduceAppMotion
    }

    var body: some View {

        ZStack {

            background

            VStack(spacing: 0) {

                TabView(selection: $page) {

                    OnboardingPage(
                        icon: .system("book"),
                        title: text.onboarding.pages[0].title,
                        text: text.onboarding.pages[0].text
                    )
                    .tag(0)

                    OnboardingPage(
                        icon: .system("laptopcomputer"),
                        title: text.onboarding.pages[1].title,
                        text: text.onboarding.pages[1].text
                    )
                    .tag(1)

                    OnboardingPage(
                        icon: .system("graduationcap.fill"),
                        title: text.onboarding.pages[2].title,
                        text: text.onboarding.pages[2].text
                    )
                    .tag(2)

                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(shouldReduceMotion ? nil : .smooth, value: page)

                bottomBar
            }
        }
    }
}

//
// MARK: - Background
//

extension OnboardingView {

    private var background: some View {

        LinearGradient(

            colors: [

                .blue.opacity(0.18),
                .purple.opacity(0.14),
                .pink.opacity(0.08),
                .clear,
            ],

            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

//
// MARK: - Bottom Button
//

extension OnboardingView {

    private var bottomBar: some View {

        VStack(spacing: 14) {

            Button(action: advance) {

                HStack {

                    Spacer()

                    Text(
                        page < 2
                            ? text.onboarding.next
                            : text.onboarding.start
                    )
                    .fontWeight(.semibold)

                    Image(
                        systemName:

                            page < 2
                            ? "arrow.right"
                            : "checkmark"
                    )

                    Spacer()
                }
            }

            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityLabel(
                page < 2 ? text.onboarding.next : text.onboarding.start
            )

            if page < 2 {

                Button(text.onboarding.skip) {

                    onFinish()

                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel(text.onboarding.skip)
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 24)

        .background(.ultraThinMaterial)
    }
}

//
// MARK: - Navigation
//

extension OnboardingView {

    private func advance() {

        if page < 2 {
            guard !shouldReduceMotion else {
                page += 1
                return
            }

            withAnimation(

                .spring(
                    response: 0.45,
                    dampingFraction: 0.85
                )
            ) {

                page += 1
            }

        } else {

            onFinish()
        }
    }
}
