//
//  MindLearnApp.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

@main
struct MindLearnApp: App {
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    var body: some Scene {
        WindowGroup {
            AppContainerView(hasSeenOnboarding: $hasSeenOnboarding)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(themeManager.accentColor)
                .environment(\.locale, Locale(identifier: language))
        }
        .modelContainer(for: LearningProgress.self)
    }
}

struct AppContainerView: View {
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack {
            if hasSeenOnboarding {
                RootView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(
                                with: .scale(scale: 0.98)
                            ),
                            removal: .opacity
                        )
                    )
            } else {
                OnboardingView(onFinish: completeOnboarding)
                    .transition(.opacity)
            }
        }
        .animation(
            .spring(response: 0.5, dampingFraction: 0.88, blendDuration: 0.2),
            value: hasSeenOnboarding
        )
    }

    private func completeOnboarding() {
        withAnimation {
            hasSeenOnboarding = true
        }
    }
}
