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
    @Environment(LocalizationStore.self) private var localization
    @State private var taskLoadState: ContentLoadState<[CodingTask]> = .loading
    @State private var topicLoadState: ContentLoadState<[LearningTopic]> = .loading

    private var appLanguage: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    private var tasks: [CodingTask] {
        guard case .loaded(let tasks) = taskLoadState else { return [] }
        return tasks
    }

    private var topics: [LearningTopic] {
        guard case .loaded(let topics) = topicLoadState else { return [] }
        return topics
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
        .toolbarTitleDisplayMode(.inline)
        .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
        .task(id: language) {
            loadContent()
        }
    }
}

extension LearningPathView {
    private func loadContent() {
        do {
            taskLoadState = .loaded(
                try CodingTaskLoader.shared.loadTasks(for: language)
            )
        } catch {
            taskLoadState = .failed(error.localizedDescription)
        }

        do {
            let topics = try LearningTopicLoader.shared.loadAllTopics().filter {
                $0.category == language.topicCategory
            }
            topicLoadState = .loaded(topics)
        } catch {
            topicLoadState = .failed(error.localizedDescription)
        }
    }

    private var taskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text.learningMode.practice)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            switch taskLoadState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 180)
            case .failed(let details):
                ContentLoadingFailureView(
                    title: text.common.loadErrorTitle,
                    description: text.common.loadErrorDescription,
                    details: details
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            case .loaded where tasks.isEmpty:
                ContentUnavailableView(
                    text.learningMode.noTasks,
                    systemImage: "keyboard"
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            case .loaded:
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

            switch topicLoadState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 180)
            case .failed(let details):
                ContentLoadingFailureView(
                    title: text.common.loadErrorTitle,
                    description: text.common.loadErrorDescription,
                    details: details
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            case .loaded where topics.isEmpty:
                ContentUnavailableView(
                    text.learningList.emptyTitle,
                    systemImage: "rectangle.grid.2x2"
                )
                .frame(maxWidth: .infinity, minHeight: 180)
            case .loaded:
                LearningGrid(
                    topics: topics,
                    gridLayout: [GridItem(.flexible())]
                )
            }
        }
    }
}
