//
//  DrawerSection.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import Foundation

// MARK: - Models

struct DrawerSection: Identifiable, Codable {

    let id: String
    let title: String
    let description: String
    let icon: String?

    let steps: [String]

    let colors: DrawerColor

    let code: String

    let category: String
}

struct DrawerColor: Codable {

    let backgroundColors: [String]
    let textColors: [String]
}

// MARK: - JSON Files (Typsicher)

enum DrawerDataFile: String, CaseIterable {

    case swiftUI = "drawerSwiftUIData"
    case swiftData = "drawerSwiftData"
    case swiftDataModel = "drawerSwiftDataModel"
    case metal = "drawerMetalData"
    case realityKit = "drawerRealityKitData"
    case spriteKit = "drawerSpriteKitData"
    case arKit = "drawerARKitData"
    case widgetKit = "drawerWidgeKitData"
    case healthKit = "drawerHealthKitData"
    case vision = "drawerVisionData"
    case speech = "drawerSpeechData"
    case html = "drawerHtmlData"
}

// MARK: - Loader Service

@MainActor
final class DrawerSectionLoader {

    static let shared = DrawerSectionLoader()

    private init() {}

    private let decoder = JSONDecoder()

    /// Cache -> verhindert mehrfaches Laden
    private var cache: [DrawerDataFile: [DrawerSection]] = [:]

    // MARK: Load

    func load(
        _ file: DrawerDataFile
    ) -> [DrawerSection] {

        // Cache nutzen
        if let cached = cache[file] {
            return cached
        }

        guard
            let url = Bundle.main.url(
                forResource: file.rawValue,
                withExtension: "json"
            )
        else {

            assertionFailure(
                "❌ \(file.rawValue).json nicht gefunden"
            )

            return []
        }

        do {

            let data = try Data(contentsOf: url)

            let sections = try decoder.decode(
                [DrawerSection].self,
                from: data
            )

            cache[file] = sections

            return sections

        } catch {

            assertionFailure(
                "❌ Decode Fehler \(file.rawValue): \(error)"
            )

            return []
        }
    }

    // MARK: Load Multiple Files

    func loadAll(
        _ files: [DrawerDataFile]
    ) -> [DrawerSection] {

        files.flatMap(load)
    }
}
