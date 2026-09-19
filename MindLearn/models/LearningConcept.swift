//
//  LearningConcept.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct LearningConcept: Identifiable, Codable {
    let id: String
    let language: ContentLanguage
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

enum LearningConceptFile: String, CaseIterable {
    case concepts
}

@MainActor
final class LearningConceptLoader {
    static let shared = LearningConceptLoader()

    private let repository: BundleContentRepository<LearningConcept, LearningConceptFile>

    convenience init() {
        self.init(repository: BundleContentRepository(subdirectory: "concepts"))
    }

    init(
        repository: BundleContentRepository<LearningConcept, LearningConceptFile>
    ) {
        self.repository = repository
    }

    func loadAllConcepts() throws -> [LearningConcept] {
        try repository.load(.concepts)
    }
}
