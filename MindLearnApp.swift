//
//  MindLearnApp.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

@main
struct MindLearnApp: App {

    @Environment(\.scenePhase)
    private var scenePhase

    @StateObject
    private var themeManager = ThemeManager()

    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false

    var body: some Scene {

        WindowGroup {

            AppContainerView(
                hasSeenOnboarding: $hasSeenOnboarding
            )

            .environmentObject(themeManager)

            .preferredColorScheme(
                themeManager.colorScheme
            )

            .tint(
                themeManager.accentColor
            )
        }

        // ⭐ optional Lifecycle Hook
        .onChange(of: scenePhase) { _, newPhase in

            switch newPhase {

            case .active:
                print("✅ App Active")

            case .background:
                print("🌙 Background")

            default:
                break
            }
        }
    }
}

struct AppContainerView: View {

    @Binding
    var hasSeenOnboarding: Bool

    var body: some View {

        ZStack {

            if hasSeenOnboarding {

                RootView()

                    .transition(

                        .asymmetric(

                            insertion:

                                .opacity
                                .combined(with: .scale(scale: 0.98)),

                            removal:

                                .opacity
                        )
                    )

            } else {

                OnboardingView {

                    completeOnboarding()
                }

                .transition(.opacity)
            }
        }

        .animation(

            .spring(

                response: 0.5,
                dampingFraction: 0.88,
                blendDuration: 0.2

            ),

            value: hasSeenOnboarding
        )
    }

    private func completeOnboarding() {

        withAnimation {

            hasSeenOnboarding = true
        }
    }
}
