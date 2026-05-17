//
//  CodingTask.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct CodingTask: Identifiable, Codable {
    let id: String
    let language: String
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

@MainActor
final class CodingTaskLoader {
    static let shared = CodingTaskLoader()

    private let decoder = JSONDecoder()
    private var cache: [ProgrammingLanguage: [CodingTask]] = [:]

    private init() {}

    func loadTasks(for language: ProgrammingLanguage) -> [CodingTask] {
        if let cached = cache[language] {
            return cached
        }

        guard let url = taskURL(for: language) else {
            assertionFailure(
                "Task file not found: \(language.taskFileName).json"
            )
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let tasks = try decoder.decode([CodingTask].self, from: data)
            cache[language] = tasks
            return tasks
        } catch {
            assertionFailure(
                "Task decode failed \(language.taskFileName): \(error)"
            )
            return []
        }
    }

    private func taskURL(for language: ProgrammingLanguage) -> URL? {
        Bundle.main.url(
            forResource: language.taskFileName,
            withExtension: "json",
            subdirectory: "tasks"
        )
            ?? Bundle.main.url(
                forResource: language.taskFileName,
                withExtension: "json"
            )
    }
}
