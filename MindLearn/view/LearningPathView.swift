//
//  LearningPathView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

struct LearningPathView: View {
    let language: ProgrammingLanguage

    @Query private var progressRecords: [LearningProgress]
    @AppStorage("language")
    private var appLanguage =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: appLanguage)
    }

    private var tasks: [CodingTask] {
        CodingTaskLoader.shared.loadTasks(for: language)
    }

    private var topics: [LearningTopic] {
        LearningTopicLoader.shared.loadAllTopics().filter {
            $0.category == language.topicCategory
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                taskSection
                cardSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(language.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension LearningPathView {
    private var taskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text.learningMode.practice)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            if tasks.isEmpty {
                ContentUnavailableView(
                    text.learningMode.noTasks,
                    systemImage: "keyboard"
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                ForEach(tasks) { task in
                    NavigationLink {
                        CodeChallengeView(task: task)
                    } label: {
                        taskRow(task)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func taskRow(_ task: CodingTask) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "keyboard")
                .foregroundStyle(
                    CategoryStyle.style(for: language.topicCategory).color
                )
                .frame(width: 36, height: 36)
                .background(
                    CategoryStyle.style(for: language.topicCategory).color
                        .opacity(0.12)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title(language: appLanguage))
                    .font(.headline)
                Text(task.instruction(language: appLanguage))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var cardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text.learningMode.relatedCards)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            if topics.isEmpty {
                ContentUnavailableView(
                    text.learningList.emptyTitle,
                    systemImage: "rectangle.grid.2x2"
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                LearningGrid(
                    topics: topics,
                    gridLayout: [GridItem(.flexible())]
                )
            }
        }
    }
}
