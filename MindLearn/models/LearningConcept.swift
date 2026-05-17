//
//  LearningConcept.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct LearningConcept: Identifiable, Codable {
    let id: String
    let language: String
    let title: LocalizedTaskText
    let summary: LocalizedTaskText
    let explanation: LocalizedTaskText
    let symbols: [String]
    let exampleCode: String
    let playgroundCode: String

    func title(language: String) -> String {
        title.value(for: language)
    }

    func summary(language: String) -> String {
        summary.value(for: language)
    }

    func explanation(language: String) -> String {
        explanation.value(for: language)
    }
}

@MainActor
final class LearningConceptLoader {
    static let shared = LearningConceptLoader()

    private let decoder = JSONDecoder()
    private var cache: [LearningConcept]?

    private init() {}

    func loadAllConcepts() -> [LearningConcept] {
        if let cache {
            return cache
        }

        guard let url = conceptURL() else {
            assertionFailure("Concept file not found: concepts.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let concepts = try decoder.decode(
                [LearningConcept].self,
                from: data
            )
            cache = concepts
            return concepts
        } catch {
            assertionFailure("Concept decode failed: \(error)")
            return []
        }
    }

    private func conceptURL() -> URL? {
        Bundle.main.url(
            forResource: "concepts",
            withExtension: "json",
            subdirectory: "concepts"
        )
            ?? Bundle.main.url(
                forResource: "concepts",
                withExtension: "json"
            )
    }
}
