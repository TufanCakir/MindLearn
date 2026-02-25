//
//  LearningTopic.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import Foundation

// MARK: - Models

struct LearningTopic: Identifiable, Codable {

    let id: String
    let title: String
    let description: String

    let icon: String?

    let steps: [String]

    let colors: ColorInfo

    let code: String

    let category: String
}

struct ColorInfo: Codable {

    let backgroundColors: [String]
    let textColors: [String]
}

// MARK: - JSON Files (Typsicher)

enum LearningTopicFile: String, CaseIterable {

    case school = "schoolData"
    case children = "childrenData"
    
    case general = "generallyData"

    case swiftUI = "SwiftUIData"

    case metal = "metalData"

    case reactNative = "reactNativeData"

    case swiftData = "swiftData"
    case swiftDataModel = "swiftDataModel"

    case arKit = "arkitData"
    case vision = "visionData"

    case widgetKit = "widgekitData"

    case healthKit = "healthkitData"
    case speech = "speechData"

    case html = "htmlData"
    case json = "jsonData"
}

// MARK: - Loader Service

@MainActor
final class LearningTopicLoader {

    static let shared = LearningTopicLoader()

    private init() {}

    private let decoder = JSONDecoder()

    /// Memory Cache -> verhindert mehrfaches JSON Decode
    private var cache: [LearningTopicFile: [LearningTopic]] = [:]

    // MARK: Load Single File

    func load(
        _ file: LearningTopicFile
    ) -> [LearningTopic] {

        // Cache benutzen
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

            let topics = try decoder.decode(
                [LearningTopic].self,
                from: data
            )

            cache[file] = topics

            return topics

        } catch {

            assertionFailure(
                "❌ Decode Fehler \(file.rawValue): \(error)"
            )

            return []
        }
    }

    // MARK: Load Multiple Files

    func loadAll(
        _ files: [LearningTopicFile]
    ) -> [LearningTopic] {

        files.flatMap(load)
    }

    // MARK: Load Everything

    func loadAllTopics() -> [LearningTopic] {

        LearningTopicFile.allCases
            .flatMap(load)
    }
}
