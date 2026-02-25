//
//  CategoryStyle.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
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
                color: Color(hex: "#5E5CE6") ?? .indigo
            )

        // MARK: RealityKit ⭐ NEW

        case "RealityKit":

            return .init(
                icon: "cube.transparent.fill",
                color: Color(hex: "#7B78FF") ?? .indigo
            )

        // MARK: SpriteKit ⭐ NEW

        case "SpriteKit":

            return .init(
                icon: "gamecontroller.fill",
                color: Color(hex: "#FF375F") ?? .pink
            )

        // MARK: SwiftUI

        case "SwiftUI":

            return .init(
                icon: "swift",
                color: Color(hex: "#FF375F") ?? .pink
            )
            
            // MARK: Swift ⭐ ADD THIS

            case "Swift":

                return .init(
                    icon: "swift",
                    color: Color(hex:"#FF5F1F") ?? .orange
                )

        // MARK: SwiftDataModel ⭐ NEW

        case "SwiftData":

            return .init(
                icon: "swiftdata",
                color: Color(hex: "#30D158") ?? .green
            )

        // MARK: Metal

        case "Metal":

            return .init(
                icon: "cpu.fill",
                color: Color(hex: "#BF5AF2") ?? .purple
            )

        // MARK: Vision

        case "Vision":

            return .init(
                icon: "vision.pro",
                color: Color(hex: "#64D2FF") ?? .cyan
            )

        // MARK: WidgetKit

        case "WidgetKit":

            return .init(
                icon: "widget.large",
                color: Color(hex: "#FFD60A") ?? .yellow
            )

        // MARK: HealthKit

        case "HealthKit":

            return .init(
                icon: "heart.fill",
                color: Color(hex: "#FF453A") ?? .red
            )

        // MARK: Speech

        case "Speech":

            return .init(
                icon: "microphone.fill",
                color: Color(hex: "#FF9F0A") ?? .orange
            )

        // MARK: HTML

        case "HTML":

            return .init(
                icon: "chevron.left.slash.chevron.right",
                color: Color(hex: "#FF6A00") ?? .orange
            )

        // MARK: JSON

        case "JSON":

            return .init(
                icon: "curlybraces",
                color: Color(hex: "#64D2FF") ?? .cyan
            )

        // MARK: React Native

        case "React Native":

            return .init(
                icon: "atom",
                color: Color(hex: "#61DAFB") ?? .cyan
            )

        // MARK: School

        case "School":

            return .init(
                icon: "graduationcap.fill",
                color: Color(hex: "#0A84FF") ?? .blue
            )

        // MARK: Kids

        case "Children":

            return .init(
                icon: "figure.child",
                color: Color(hex: "#FF9F0A") ?? .orange
            )

        // MARK: Completely

        case "Completely":

            return .init(
                icon: "swift",
                color: Color(hex: "#FF5F1F") ?? .orange
            )

        // MARK: General

        case "General":

            return .init(
                icon: "book.fill",
                color: Color(hex: "#8E8E93") ?? .gray
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
