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
        for category: String
    ) -> CategoryStyle {

        switch category {

        // MARK: ARKit

        case "ARKit":

            return .init(
                icon: "arkit",
                color: Color(hex: "#5856D6") ?? .indigo
            )

        // MARK: RealityKit

        case "RealityKit":

            return .init(
                icon: "cube.transparent.fill",
                color: Color(hex: "#32ADE6") ?? .cyan
            )

        // MARK: SpriteKit

        case "SpriteKit":

            return .init(
                icon: "gamecontroller.fill",
                color: Color(hex: "#FF2D55") ?? .pink
            )

        // MARK: SwiftUI

        case "SwiftUI":

            return .init(
                icon: "swift",
                color: Color(hex: "#0A84FF") ?? .blue
            )

        // MARK: Swift

        case "Swift":

            return .init(
                icon: "swift",
                color: Color(hex: "#FF6B1A") ?? .orange
            )

        // MARK: SwiftData

        case "SwiftData":

            return .init(
                icon: "swiftdata",
                color: Color(hex: "#34C759") ?? .green
            )

        // MARK: Metal

        case "Metal":

            return .init(
                icon: "cpu.fill",
                color: Color(hex: "#8E8E93") ?? .gray
            )

        // MARK: Vision

        case "Vision":

            return .init(
                icon: "vision.pro",
                color: Color(hex: "#00C7BE") ?? .cyan
            )

        // MARK: WidgetKit

        case "WidgetKit":

            return .init(
                icon: "widget.large",
                color: Color(hex: "#AF52DE") ?? .purple
            )

        // MARK: HealthKit

        case "HealthKit":

            return .init(
                icon: "heart.fill",
                color: Color(hex: "#FF3B30") ?? .red
            )

        // MARK: Speech

        case "Speech":

            return .init(
                icon: "microphone.fill",
                color: Color(hex: "#BF5AF2") ?? .purple
            )

        // MARK: HTML

        case "HTML":

            return .init(
                icon: "chevron.left.forwardslash.chevron.right",
                color: Color(hex: "#E44D26") ?? .orange
            )

        // MARK: JSON

        case "JSON":

            return .init(
                icon: "curlybraces",
                color: Color(hex: "#5AC8FA") ?? .cyan
            )

        // MARK: React Native

        case "React Native":

            return .init(
                icon: "atom",
                color: Color(hex: "#00AEEF") ?? .cyan
            )

        // MARK: School

        case "School":

            return .init(
                icon: "graduationcap.fill",
                color: Color(hex: "#007AFF") ?? .blue
            )

        // MARK: Kids

        case "Children":

            return .init(
                icon: "figure.child",
                color: Color(hex: "#FFCC00") ?? .yellow
            )

        // MARK: Completely

        case "Completely":

            return .init(
                icon: "swift",
                color: Color(hex: "#FF6B1A") ?? .orange
            )

        // MARK: General

        case "General":

            return .init(
                icon: "book.fill",
                color: Color(hex: "#6E6E73") ?? .gray
            )

        // MARK: Default

        default:

            return .init(
                icon: "doc.text",
                color: .accentColor
            )
        }
    }
}
