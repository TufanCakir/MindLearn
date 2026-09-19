//
//  LearningListViewModel.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class LearningListViewModel {

    // MARK: Published

    private(set) var topics: [LearningTopic] = []

    var searchText = ""

    var selectedCategory: ContentCategoryFilter = .all

    private(set) var categories: [ContentCategoryFilter] = []

    private(set) var loadingError: Error?

    private let topicProvider: any LearningTopicProviding

    // MARK: Init
    convenience init() {
        self.init(topicProvider: LearningTopicLoader.shared)
    }

    init(topicProvider: any LearningTopicProviding) {
        self.topicProvider = topicProvider
        loadTopics()
    }

    // MARK: Filtering (⭐ BEST)

    var filteredTopics: [LearningTopic] {

        guard !topics.isEmpty else { return [] }

        let query =
            searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        return topics.filter { topic in

            matchesCategory(topic)
                && matchesSearch(
                    topic,
                    query: query
                )
        }
    }
}

// MARK: Category + Search

extension LearningListViewModel {

    fileprivate func matchesCategory(
        _ topic: LearningTopic
    ) -> Bool {

        guard let category = selectedCategory.category else { return true }

        return topic.category == category
    }

    fileprivate func matchesSearch(
        _ topic: LearningTopic,
        query: String
    ) -> Bool {

        guard !query.isEmpty else {

            return true
        }

        return topic.searchableText
            .localizedCaseInsensitiveContains(query)
    }
}

// MARK: Category Color

extension LearningListViewModel {

    func colorForCategory(
        _ filter: ContentCategoryFilter
    ) -> Color {
        guard let category = filter.category else { return .accentColor }

        // Use the color associated with the category style.
        return
            CategoryStyle
            .style(for: category)
            .color
    }
}

// MARK: Loading

extension LearningListViewModel {

    fileprivate func loadTopics() {

        do {
            topics = try topicProvider.loadAllTopics()
            loadingError = nil
        } catch {
            topics = []
            loadingError = error
        }

        categories =
            buildCategories(
                from: topics
            )
    }

    fileprivate func buildCategories(
        from topics: [LearningTopic]
    ) -> [ContentCategoryFilter] {

        let unique = Set(topics.map(\.category))

        return [.all] + unique.sorted { $0.rawValue < $1.rawValue }
            .map(ContentCategoryFilter.category)
    }
}
