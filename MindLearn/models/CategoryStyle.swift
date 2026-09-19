//
//  CategoryStyle.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct CategoryStyle {

    let icon: String
    let color: Color
}

extension CategoryStyle {

    static func style(
        for category: ContentCategory
    ) -> CategoryStyle {

        switch category {

        // MARK: ARKit

        case .arKit:

            return .init(
                icon: "arkit",
                color: Color(hex: "#5856D6") ?? .indigo
            )

        // MARK: RealityKit

        case .realityKit:

            return .init(
                icon: "cube.transparent.fill",
                color: Color(hex: "#32ADE6") ?? .cyan
            )

        // MARK: SpriteKit

        case .spriteKit:

            return .init(
                icon: "gamecontroller.fill",
                color: Color(hex: "#FF2D55") ?? .pink
            )

        // MARK: SwiftUI

        case .swiftUI:

            return .init(
                icon: "swift",
                color: Color(hex: "#0A84FF") ?? .blue
            )

        // MARK: Swift

        case .swift:

            return .init(
                icon: "swift",
                color: Color(hex: "#FF6B1A") ?? .orange
            )

        // MARK: SwiftData

        case .swiftData:

            return .init(
                icon: "swiftdata",
                color: Color(hex: "#34C759") ?? .green
            )

        // MARK: Metal

        case .metal:

            return .init(
                icon: "cpu.fill",
                color: Color(hex: "#8E8E93") ?? .gray
            )

        // MARK: Vision

        case .vision:

            return .init(
                icon: "vision.pro",
                color: Color(hex: "#00C7BE") ?? .cyan
            )

        // MARK: WidgetKit

        case .widgetKit:

            return .init(
                icon: "widget.large",
                color: Color(hex: "#AF52DE") ?? .purple
            )

        // MARK: HealthKit

        case .healthKit:

            return .init(
                icon: "heart.fill",
                color: Color(hex: "#FF3B30") ?? .red
            )

        // MARK: Speech

        case .speech:

            return .init(
                icon: "microphone.fill",
                color: Color(hex: "#BF5AF2") ?? .purple
            )

        // MARK: HTML

        case .html:

            return .init(
                icon: "chevron.left.forwardslash.chevron.right",
                color: Color(hex: "#E44D26") ?? .orange
            )

        // MARK: JSON

        case .json:

            return .init(
                icon: "curlybraces",
                color: Color(hex: "#5AC8FA") ?? .cyan
            )

        // MARK: React Native

        case .reactNative:

            return .init(
                icon: "atom",
                color: Color(hex: "#00AEEF") ?? .cyan
            )

        // MARK: School

        case .school:

            return .init(
                icon: "graduationcap.fill",
                color: Color(hex: "#007AFF") ?? .blue
            )

        // MARK: Kids

        case .children:

            return .init(
                icon: "figure.child",
                color: Color(hex: "#FFCC00") ?? .yellow
            )

        // MARK: Completely

        case .completely:

            return .init(
                icon: "swift",
                color: Color(hex: "#FF6B1A") ?? .orange
            )

        // MARK: General

        case .general:

            return .init(
                icon: "book.fill",
                color: Color(hex: "#6E6E73") ?? .gray
            )

        // MARK: Default

        }
    }
}
