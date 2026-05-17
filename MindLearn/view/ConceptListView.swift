//
//  ConceptListView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct ConceptListView: View {
    @AppStorage("language")
    private var appLanguage =
        Locale.current.language.languageCode?.identifier ?? "en"

    @State private var searchText = ""
    @State private var selectedLanguage = "all"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: appLanguage)
    }

    private var concepts: [LearningConcept] {
        LearningConceptLoader.shared.loadAllConcepts()
    }

    private var languageFilters: [String] {
        ["all"] + Array(Set(concepts.map(\.language))).sorted()
    }

    private var filteredConcepts: [LearningConcept] {
        concepts.filter { concept in
            let matchesLanguage =
                selectedLanguage == "all"
                || concept.language == selectedLanguage
            let query = searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).lowercased()

            guard !query.isEmpty else {
                return matchesLanguage
            }

            return matchesLanguage
                && (concept.title(language: appLanguage).lowercased().contains(
                    query
                )
                    || concept.summary(language: appLanguage).lowercased()
                        .contains(query)
                    || concept.symbols.joined(separator: " ").lowercased()
                        .contains(query))
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                filterRow
                conceptRows
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(text.concepts.title)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: text.concepts.searchPlaceholder
        )
    }
}

extension ConceptListView {
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(text.concepts.title)
                .font(.title2.bold())

            Text(text.concepts.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(languageFilters, id: \.self) { language in
                    Button {
                        selectedLanguage = language
                    } label: {
                        Text(title(for: language))
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(
                        selectedLanguage == language ? .white : .primary
                    )
                    .background(
                        Capsule(style: .continuous)
                            .fill(
                                selectedLanguage == language
                                    ? Color.accentColor
                                    : Color(.secondarySystemGroupedBackground)
                            )
                    )
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var conceptRows: some View {
        LazyVStack(spacing: 10) {
            if filteredConcepts.isEmpty {
                ContentUnavailableView(
                    text.learningList.emptyTitle,
                    systemImage: "magnifyingglass",
                    description: Text(text.learningList.emptyDescription)
                )
                .frame(maxWidth: .infinity, minHeight: 220)
            } else {
                ForEach(filteredConcepts) { concept in
                    NavigationLink {
                        ConceptDetailView(concept: concept)
                    } label: {
                        conceptRow(concept)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func conceptRow(_ concept: LearningConcept) -> some View {
        HStack(spacing: 12) {
            icon(for: concept)

            VStack(alignment: .leading, spacing: 6) {
                Text(concept.title(language: appLanguage))
                    .font(.headline)

                Text(concept.summary(language: appLanguage))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                if !concept.symbols.isEmpty {
                    Text(concept.symbols.joined(separator: "  "))
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }

    private func icon(for concept: LearningConcept) -> some View {
        Image(systemName: iconName(for: concept.language))
            .font(.headline)
            .foregroundStyle(Color.accentColor)
            .frame(width: 38, height: 38)
            .background(Color.accentColor.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func title(for language: String) -> String {
        guard language != "all" else {
            return text.concepts.all
        }

        return language
    }

    private func iconName(for language: String) -> String {
        switch language {
        case "HTML": "chevron.left.forwardslash.chevron.right"
        case "React Native": "atom"
        case "Swift", "SwiftUI": "swift"
        default: "lightbulb"
        }
    }
}

#Preview {
    NavigationStack {
        ConceptListView()
    }
}
