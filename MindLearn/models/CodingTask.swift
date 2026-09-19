//
//  CodingTask.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct CodingTask: Identifiable, Codable {
    let id: String
    let language: ContentLanguage
    let title: LocalizedTaskText
    let explanation: LocalizedTaskText
    let instruction: LocalizedTaskText
    let starterCode: String
    let expectedKeywords: [String]
    let solution: String
    let hint: LocalizedTaskText

    func evaluate(_ code: String) -> CodingTaskResult {
        let normalizedCode = code.lowercased()
        let missing = expectedKeywords.filter {
            !normalizedCode.contains($0.lowercased())
        }

        return CodingTaskResult(
            isCorrect: missing.isEmpty,
            missingKeywords: missing
        )
    }

    func title(language: String) -> String {
        title.value(for: language)
    }

    func explanation(language: String) -> String {
        explanation.value(for: language)
    }

    func instruction(language: String) -> String {
        instruction.value(for: language)
    }

    func hint(language: String) -> String {
        hint.value(for: language)
    }
}

struct LocalizedTaskText: Codable {
    let de: String
    let en: String

    private enum CodingKeys: String, CodingKey {
        case de
        case en
    }

    init(de: String, en: String) {
        self.de = de
        self.en = en
    }

    init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            self.de = value
            self.en = value
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.de = try container.decode(String.self, forKey: .de)
        self.en = try container.decode(String.self, forKey: .en)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(de, forKey: .de)
        try container.encode(en, forKey: .en)
    }

    func value(for language: String) -> String {
        language == "de" ? de : en
    }
}

struct CodingTaskResult {
    let isCorrect: Bool
    let missingKeywords: [String]
}

enum CodingTaskFile: String, CaseIterable {
    case swiftUI = "swiftUITasks"
    case swift = "swiftTasks"
    case html = "htmlTasks"
    case json = "jsonTasks"
    case reactNative = "reactNativeTasks"
    case swiftData = "swiftDataTasks"
}

@MainActor
final class CodingTaskLoader {
    static let shared = CodingTaskLoader()

    private let repository: BundleContentRepository<CodingTask, CodingTaskFile>

    convenience init() {
        self.init(repository: BundleContentRepository(subdirectory: "tasks"))
    }

    init(repository: BundleContentRepository<CodingTask, CodingTaskFile>) {
        self.repository = repository
    }

    func loadTasks(for language: ProgrammingLanguage) throws -> [CodingTask] {
        try repository.load(language.taskFile)
    }

    func loadAllTasks() throws -> [CodingTask] {
        try repository.loadAll(CodingTaskFile.allCases)
    }
}
