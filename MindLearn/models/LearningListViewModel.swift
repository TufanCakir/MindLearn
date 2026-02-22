//
//  LearningListViewModel.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

internal import Combine
import Foundation

@MainActor
final class LearningListViewModel: ObservableObject {

    // MARK: Published

    @Published private(set)
        var topics: [LearningTopic] = []

    @Published var searchText = ""

    @Published var selectedCategory =
        Category.all

    @Published private(set)
        var categories: [String] = []

    enum Category {

        static let all = "Alle"
    }

    // MARK: Dependencies

    private(set)
        var favorites: Set<String>

    // MARK: Init

    init(
        favorites: Set<String>
    ) {

        self.favorites = favorites

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

        selectedCategory == Category.all

            ||

            topic.category
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

                ==

                selectedCategory
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
    }

    fileprivate func matchesSearch(
        _ topic: LearningTopic,
        query: String
    ) -> Bool {

        guard !query.isEmpty else {

            return true
        }

        return topic.title
            .localizedCaseInsensitiveContains(query)

            ||

            topic.description
                .localizedCaseInsensitiveContains(query)
    }
}

// MARK: Loading

extension LearningListViewModel {

    fileprivate func loadTopics() {

        topics =
            LearningTopicLoader
            .shared
            .loadAllTopics()

        categories =
            buildCategories(
                from: topics
            )
    }

    fileprivate func buildCategories(
        from topics: [LearningTopic]
    ) -> [String] {

        let unique = Set(

            topics.map {

                $0.category
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
            }
        )

        return [Category.all]
            + unique.sorted()
    }
}

// MARK: Favorites

extension LearningListViewModel {

    func updateFavorites(
        _ newFavorites: Set<String>
    ) {

        favorites = newFavorites
    }
}
