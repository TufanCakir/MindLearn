//
//  LearningTopic.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct LearningTopic: Identifiable, Codable {

    let id: String
    let title: LocalizedTaskText
    let description: LocalizedTaskText

    let icon: String?

    let steps: [LocalizedTaskText]

    let colors: ColorInfo

    let code: String

    let category: String

    func title(language: String) -> String {
        title.value(for: language)
    }

    func description(language: String) -> String {
        description.value(for: language)
    }

    func steps(language: String) -> [String] {
        steps.map { $0.value(for: language) }
    }

    var searchableText: String {
        ([title.de, title.en, description.de, description.en]
            + steps.flatMap { [$0.de, $0.en] })
            .joined(separator: " ")
    }
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
