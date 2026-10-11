//
//  GlobalSearchView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct GlobalSearchView: View {
    @Environment(LocalizationStore.self) private var localization

    @State private var query = ""
    @State private var topics: [LearningTopic] = []
    @State private var concepts: [LearningConcept] = []
    @State private var errorDetails: String?

    private var language: String {
        localization.language
    }

    private var normalizedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var matchingTopics: [LearningTopic] {
        guard !normalizedQuery.isEmpty else { return [] }

        return topics.filter { topic in
            topic.searchableText.localizedStandardContains(normalizedQuery)
                || topic.category.rawValue.localizedStandardContains(
                    normalizedQuery
                )
                || topic.code.localizedStandardContains(normalizedQuery)
        }
    }

    private var matchingConcepts: [LearningConcept] {
        guard !normalizedQuery.isEmpty else { return [] }

        return concepts.filter { concept in
            [
                concept.title.de,
                concept.title.en,
                concept.summary.de,
                concept.summary.en,
                concept.explanation.de,
                concept.explanation.en,
                concept.symbols.joined(separator: " "),
                concept.exampleCode,
            ]
            .joined(separator: " ")
            .localizedStandardContains(normalizedQuery)
        }
    }

    var body: some View {
        Group {
            if let errorDetails {
                ContentLoadingFailureView(
                    title: localization.text.common.loadErrorTitle,
                    description: localization.text.common.loadErrorDescription,
                    details: errorDetails
                )
                .padding()
            } else if normalizedQuery.isEmpty {
                ContentUnavailableView(
                    title,
                    systemImage: "magnifyingglass",
                    description: Text(searchHint)
                )
            } else if matchingTopics.isEmpty && matchingConcepts.isEmpty {
                ContentUnavailableView.search(text: normalizedQuery)
            } else {
                SearchResultsList(
                    topics: matchingTopics,
                    concepts: matchingConcepts,
                    language: language,
                    topicSectionTitle: topicSectionTitle,
                    conceptSectionTitle: conceptSectionTitle
                )
            }
        }
        .navigationTitle(title)
        .searchable(text: $query, prompt: searchPrompt)
        .searchSuggestions {
            ForEach(suggestions, id: \.self) { suggestion in
                Text(suggestion).searchCompletion(suggestion)
            }
        }
        .task {
            loadContent()
        }
    }

    private var title: String {
        language == "de" ? "Suchen" : "Search"
    }

    private var searchPrompt: String {
        language == "de" ? "Themen, Code und Hilfe" : "Topics, code, and help"
    }

    private var searchHint: String {
        language == "de"
            ? "Durchsuche alle Lernkarten und Hilfe-Begriffe an einem Ort."
            : "Search all learning cards and help concepts in one place."
    }

    private var topicSectionTitle: String {
        language == "de" ? "Lernkarten" : "Learning cards"
    }

    private var conceptSectionTitle: String {
        language == "de" ? "Hilfe & Begriffe" : "Help & concepts"
    }

    private var suggestions: [String] {
        ["SwiftUI", "UIKit", "SpriteKit", "Metal"]
    }

    private func loadContent() {
        do {
            topics = try LearningTopicLoader.shared.loadAllTopics()
            concepts = try LearningConceptLoader.shared.loadAllConcepts()
            errorDetails = nil
        } catch {
            errorDetails = error.localizedDescription
        }
    }
}

private struct SearchResultsList: View {
    let topics: [LearningTopic]
    let concepts: [LearningConcept]
    let language: String
    let topicSectionTitle: String
    let conceptSectionTitle: String

    var body: some View {
        List {
            if !topics.isEmpty {
                Section(topicSectionTitle) {
                    ForEach(topics) { topic in
                        NavigationLink {
                            LearningDetailView(topic: topic)
                        } label: {
                            TopicSearchRow(
                                title: topic.title(language: language),
                                subtitle: topic.description(language: language),
                                category: topic.category,
                                icon: topic.icon
                            )
                        }
                    }
                }
            }

            if !concepts.isEmpty {
                Section(conceptSectionTitle) {
                    ForEach(concepts) { concept in
                        NavigationLink {
                            ConceptDetailView(concept: concept)
                        } label: {
                            ConceptSearchRow(
                                title: concept.title(language: language),
                                subtitle: concept.summary(language: language),
                                languageName: concept.language.rawValue
                            )
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct TopicSearchRow: View {
    let title: String
    let subtitle: String
    let category: ContentCategory
    let icon: String?

    var body: some View {
        Label {
            SearchRowText(
                title: title,
                subtitle: subtitle,
                badge: category.rawValue
            )
        } icon: {
            Image(systemName: icon ?? CategoryStyle.style(for: category).icon)
                .foregroundStyle(CategoryStyle.style(for: category).color)
        }
    }
}

private struct ConceptSearchRow: View {
    let title: String
    let subtitle: String
    let languageName: String

    var body: some View {
        Label {
            SearchRowText(title: title, subtitle: subtitle, badge: languageName)
        } icon: {
            Image(systemName: "lightbulb")
                .foregroundStyle(.orange)
        }
    }
}

private struct SearchRowText: View {
    let title: String
    let subtitle: String
    let badge: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .lineLimit(2)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Text(badge)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tint)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PreviewRoot {
        NavigationStack {
            GlobalSearchView()
        }
    }
}
