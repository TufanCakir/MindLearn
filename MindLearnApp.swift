//
//  MindLearnApp.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

@main
struct MindLearnApp: App {

    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var themeManager: ThemeManager

    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false

    init() {
        _themeManager = StateObject(wrappedValue: ThemeManager())
    }

    var body: some Scene {
        WindowGroup {
            rootContent
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(themeManager.accentColor)
        }
    }

    @ViewBuilder
    private var rootContent: some View {
        Group {
            if hasSeenOnboarding {
                RootView()
            } else {
                OnboardingView {
                    hasSeenOnboarding = true
                }
            }
        }
    }
}
