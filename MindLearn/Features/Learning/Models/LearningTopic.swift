//
//  LearningTopic.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct LearningTopic: LearningContent, Identifiable {

    let id: String
    let title: LocalizedTaskText
    let description: LocalizedTaskText

    let icon: String?

    let steps: [LocalizedTaskText]

    let colors: ColorInfo

    let code: String

    let category: ContentCategory

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

    case general = "generalData"

    case swiftUI = "SwiftUIData"

    case metal = "metalData"

    case reactNative = "reactNativeData"

    case swiftData = "swiftData"
    case swiftDataModel = "swiftDataModel"

    case arKit = "arkitData"
    case vision = "visionData"

    case widgetKit = "widgetKitData"

    case healthKit = "healthkitData"
    case speech = "speechData"

    case html = "htmlData"
    case json = "jsonData"
}

// MARK: - Loader Service

@MainActor
protocol LearningTopicProviding {
    func loadAllTopics() throws -> [LearningTopic]
}

@MainActor
final class LearningTopicLoader: LearningTopicProviding {
    static let shared = LearningTopicLoader()

    private let repository: BundleContentRepository<LearningTopic, LearningTopicFile>

    convenience init() {
        self.init(repository: BundleContentRepository())
    }

    init(repository: BundleContentRepository<LearningTopic, LearningTopicFile>) {
        self.repository = repository
    }

    func load(_ file: LearningTopicFile) throws -> [LearningTopic] {
        try repository.load(file)
    }

    func loadAll(_ files: [LearningTopicFile]) throws -> [LearningTopic] {
        try repository.loadAll(files)
    }

    func loadAllTopics() throws -> [LearningTopic] {
        try loadAll(LearningTopicFile.allCases)
    }
}
