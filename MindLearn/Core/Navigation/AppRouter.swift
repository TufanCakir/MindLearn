//
//  AppNavigation.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Observation

enum AppTab: CaseIterable, Hashable {
    case home
    case help
    case favorites
    case settings
}

@MainActor
@Observable
final class AppRouter {
    static let shared = AppRouter()

    var selectedTab: AppTab

    init(selectedTab: AppTab = .home) {
        self.selectedTab = selectedTab
    }

    func open(_ tab: AppTab) {
        selectedTab = tab
    }
}
