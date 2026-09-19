//
//  PreviewRoot.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

struct PreviewRoot<Content: View>: View {
    let content: Content
    @State private var theme = ThemeManager()
    @State private var localization: LocalizationStore?
    @State private var router = AppRouter()

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
        _localization = State(initialValue: try? LocalizationStore())
    }

    var body: some View {
        if let localization {
            content
                .environment(theme)
                .environment(localization)
                .environment(router)
                .environment(\.locale, localization.locale)
                .modelContainer(
                    for: [LearningProgress.self, Favorite.self],
                    inMemory: true
                )
        } else {
            ContentUnavailableView(
                "Preview Unavailable",
                systemImage: "exclamationmark.triangle"
            )
        }
    }
}
