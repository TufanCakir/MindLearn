//
//  AppNavigation.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

import Foundation

enum AppNavigation {

    @MainActor
    static func openJSONValidator() {

        NotificationCenter.default.post(
            name: .openJSONValidator,
            object: nil
        )
    }

    @MainActor
    static func openJSONEscape() {

        NotificationCenter.default.post(
            name: .openJSONEscape,
            object: nil
        )
    }

    @MainActor
    static func openFavorites() {

        NotificationCenter.default.post(
            name: .openFavorites,
            object: nil
        )
    }
}
