//
//  AppNavigation.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

enum AppNavigation {

    enum Destination {
        case favorites
    }

    @MainActor
    static func open(_ destination: Destination) {
        NotificationCenter.default.post(
            name: .openAppDestination,
            object: destination
        )
    }
}

extension Notification.Name {
    static let openAppDestination =
        Notification.Name("openAppDestination")
}
