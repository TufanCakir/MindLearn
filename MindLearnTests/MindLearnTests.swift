//
//  MindLearnTests.swift
//  MindLearnTests
//
//  Created by Tufan Cakir on 15.09.26.
//

import Foundation
import SwiftData
import Testing
@testable import MindLearn

@MainActor
struct MindLearnTests {
    private struct SampleContent: Decodable {
        let id: String
    }

    private enum SampleFile: String {
        case sample
    }

    @Test("Router opens the requested tab")
    func routerOpensRequestedTab() {
        let router = AppRouter()

        router.open(.favorites)

        #expect(router.selectedTab == .favorites)
    }

    @Test("All-category filter is independent from its localized title")
    func allCategoryFilterUsesLocalizedTitleOnlyForDisplay() {
        let filter = ContentCategoryFilter.all
        let categoryFilter = ContentCategoryFilter.category(.swiftUI)

        #expect(filter.category == nil)
        #expect(filter.title(allTitle: "Alle") == "Alle")
        #expect(filter.title(allTitle: "All") == "All")
        #expect(categoryFilter.category == .swiftUI)
        #expect(categoryFilter.title(allTitle: "All") == "SwiftUI")
    }

    @Test("Favorite toggle inserts and removes a SwiftData record")
    func favoriteTogglePersistsRecord() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Favorite.self,
            configurations: configuration
        )
        let context = ModelContext(container)

        try FavoritesRepository.toggle(
            topicID: "swift-basics",
            favorites: [],
            in: context
        )
        var favorites = try context.fetch(FetchDescriptor<Favorite>())
        #expect(favorites.map(\.topicID) == ["swift-basics"])

        try FavoritesRepository.toggle(
            topicID: "swift-basics",
            favorites: favorites,
            in: context
        )
        favorites = try context.fetch(FetchDescriptor<Favorite>())
        #expect(favorites.isEmpty)
    }

    @Test("Every learning topic file decodes and contains valid content")
    func learningTopicFilesDecode() throws {
        for file in LearningTopicFile.allCases {
            let topics = try LearningTopicLoader.shared.load(file)

            #expect(!topics.isEmpty, "\(file.rawValue).json contains no topics")
            validate(topics, source: file.rawValue)
            validateColors(
                topics.map(\.colors),
                source: file.rawValue
            )
        }
    }

    @Test("Every drawer file decodes and contains valid content")
    func drawerFilesDecode() throws {
        for file in DrawerDataFile.allCases {
            let sections = try DrawerSectionLoader.shared.load(file)

            #expect(!sections.isEmpty, "\(file.rawValue).json contains no sections")
            validate(sections, source: file.rawValue)
            validateColors(
                sections.map(\.colors),
                source: file.rawValue
            )
        }
    }

    @Test("Learning topic IDs are globally unique")
    func learningTopicIDsAreUnique() throws {
        expectUniqueIDs(
            try LearningTopicLoader.shared.loadAllTopics(),
            source: "learning topics"
        )
    }

    @Test("Drawer section IDs are globally unique")
    func drawerSectionIDsAreUnique() throws {
        expectUniqueIDs(
            try DrawerSectionLoader.shared.loadAllSections(),
            source: "drawer sections"
        )
    }

    @Test("Every coding task file decodes and contains valid content")
    func codingTaskFilesDecode() throws {
        for language in ProgrammingLanguage.allCases {
            let tasks = try CodingTaskLoader.shared.loadTasks(for: language)

            #expect(!tasks.isEmpty, "\(language.taskFile.rawValue).json contains no tasks")
            for task in tasks {
                #expect(!task.id.isEmpty)
                #expect(task.language == language.contentLanguage)
                #expect(!task.title.de.isEmpty && !task.title.en.isEmpty)
                #expect(!task.instruction.de.isEmpty && !task.instruction.en.isEmpty)
                #expect(!task.starterCode.isEmpty)
                #expect(!task.solution.isEmpty)
                #expect(!task.expectedKeywords.isEmpty)
            }
        }

        expectUniqueStrings(
            try CodingTaskLoader.shared.loadAllTasks().map(\.id),
            source: "coding tasks"
        )
    }

    @Test("Concepts decode and contain valid bilingual content")
    func conceptsDecode() throws {
        let concepts = try LearningConceptLoader.shared.loadAllConcepts()

        #expect(!concepts.isEmpty)
        for concept in concepts {
            #expect(!concept.id.isEmpty)
            #expect(!concept.language.rawValue.isEmpty)
            #expect(!concept.title.de.isEmpty && !concept.title.en.isEmpty)
            #expect(!concept.summary.de.isEmpty && !concept.summary.en.isEmpty)
            #expect(!concept.explanation.de.isEmpty && !concept.explanation.en.isEmpty)
            #expect(!concept.exampleCode.isEmpty)
            #expect(!concept.playgroundCode.isEmpty)
        }

        expectUniqueStrings(concepts.map(\.id), source: "concepts")
    }

    @Test("Malformed content returns a typed decoding error")
    func malformedContentReturnsTypedError() {
        let repository = BundleContentRepository<SampleContent, SampleFile> { _ in
            Data("not-json".utf8)
        }

        do {
            _ = try repository.load(.sample)
            Issue.record("Expected decoding to fail")
        } catch ContentRepositoryError.decodingFailed(let resource, _) {
            #expect(resource == SampleFile.sample.rawValue)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Empty content returns a typed error")
    func emptyContentReturnsTypedError() {
        let repository = BundleContentRepository<SampleContent, SampleFile> { _ in
            Data("[]".utf8)
        }

        do {
            _ = try repository.load(.sample)
            Issue.record("Expected empty content to fail")
        } catch ContentRepositoryError.emptyContent(let resource) {
            #expect(resource == SampleFile.sample.rawValue)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Localization store persists the selected language")
    func localizationStorePersistsLanguage() throws {
        let suiteName = "MindLearnTests.LocalizationStore"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let store = try LocalizationStore(defaults: defaults)
        store.language = "de"

        #expect(defaults.string(forKey: LocalizationStore.languageKey) == "de")
        #expect(store.locale.language.languageCode?.identifier == "de")
    }

    private func validate<Content: LearningContent>(
        _ content: [Content],
        source: String
    ) {
        for item in content {
            #expect(
                !item.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Empty ID in \(source)"
            )
            #expect(
                !item.category.rawValue.isEmpty,
                "Empty category for \(item.id) in \(source)"
            )
            #expect(
                !item.title.de.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Missing German title for \(item.id) in \(source)"
            )
            #expect(
                !item.title.en.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Missing English title for \(item.id) in \(source)"
            )
            #expect(
                !item.description.de.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Missing German description for \(item.id) in \(source)"
            )
            #expect(
                !item.description.en.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Missing English description for \(item.id) in \(source)"
            )
            #expect(!item.steps.isEmpty, "Missing steps for \(item.id) in \(source)")
            for step in item.steps {
                #expect(
                    !step.de.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    "Missing German step for \(item.id) in \(source)"
                )
                #expect(
                    !step.en.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    "Missing English step for \(item.id) in \(source)"
                )
            }
            #expect(
                !item.code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                "Missing code example for \(item.id) in \(source)"
            )
        }

        expectUniqueIDs(content, source: source)
    }

    private func validateColors(
        _ colors: [ColorInfo],
        source: String
    ) {
        validateColorValues(
            colors.flatMap { $0.backgroundColors + $0.textColors },
            source: source
        )
    }

    private func validateColors(
        _ colors: [DrawerColor],
        source: String
    ) {
        validateColorValues(
            colors.flatMap { $0.backgroundColors + $0.textColors },
            source: source
        )
    }

    private func validateColorValues(_ values: [String], source: String) {
        #expect(!values.isEmpty, "Missing colors in \(source)")
        for value in values {
            let hex = value.trimmingCharacters(in: .whitespacesAndNewlines)
            #expect(
                hex.range(of: "^#?[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$", options: .regularExpression) != nil,
                "Invalid color \(value) in \(source)"
            )
        }
    }

    private func expectUniqueIDs<Content: LearningContent>(
        _ content: [Content],
        source: String
    ) {
        let duplicates = Dictionary(grouping: content, by: \.id)
            .filter { $0.value.count > 1 }
            .keys
            .sorted()

        #expect(duplicates.isEmpty, "Duplicate IDs in \(source): \(duplicates)")
    }

    private func expectUniqueStrings(_ values: [String], source: String) {
        let duplicates = Dictionary(grouping: values, by: { $0 })
            .filter { $0.value.count > 1 }
            .keys
            .sorted()

        #expect(duplicates.isEmpty, "Duplicate IDs in \(source): \(duplicates)")
    }
}
