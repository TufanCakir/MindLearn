//
//  LanguageSelectionView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

struct LanguageSelectionView: View {
    @Query private var progressRecords: [LearningProgress]
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 240), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                languageGrid
                allCardsLink
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

extension LanguageSelectionView {
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(text.learningMode.title)
                .font(.title2.bold())

            Text(text.learningMode.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var languageGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(ProgrammingLanguage.allCases) { language in
                NavigationLink {
                    LearningPathView(language: language)
                } label: {
                    languageCard(language)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func languageCard(_ language: ProgrammingLanguage) -> some View {
        let style = CategoryStyle.style(for: language.topicCategory)
        let topics = topics(for: language)
        let tasks = CodingTaskLoader.shared.loadTasks(for: language)
        let completed = completedTopicCount(for: topics)

        return VStack(alignment: .leading, spacing: 12) {
            Image(systemName: language.icon)
                .font(.title2)
                .foregroundStyle(style.color)
                .frame(width: 44, height: 44)
                .background(style.color.opacity(0.12))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(language.title)
                    .font(.headline)

                Text(
                    "\(tasks.count) \(text.learningMode.tasks) • \(topics.count) \(text.learningMode.cards)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            ProgressView(
                value: topics.isEmpty ? 0 : Double(completed),
                total: Double(max(topics.count, 1))
            )
            .tint(style.color)

            Text("\(completed)/\(topics.count) \(text.learningMode.completed)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 170, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
        )
    }

    private var allCardsLink: some View {
        NavigationLink {
            LearningListView()
        } label: {
            Label(text.learningMode.allCards, systemImage: "rectangle.grid.2x2")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.bordered)
    }

    private func topics(for language: ProgrammingLanguage) -> [LearningTopic] {
        LearningTopicLoader.shared.loadAllTopics().filter {
            $0.category == language.topicCategory
        }
    }

    private func completedTopicCount(for topics: [LearningTopic]) -> Int {
        let topicIDs = Set(topics.map(\.id))

        return progressRecords.filter {
            topicIDs.contains($0.topicID) && $0.status == .understood
        }.count
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionView()
    }
}
