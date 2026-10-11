//
//  PracticeView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct PracticeView: View {
    @Environment(LocalizationStore.self) private var localization
    @State private var loadState:
        ContentLoadState<[ProgrammingLanguage: [CodingTask]]> = .loading

    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 240), spacing: 12)
    ]

    private var title: String {
        localization.language == "de" ? "Praxis" : "Practice"
    }

    private var subtitle: String {
        localization.language == "de"
            ? "Wähle eine Sprache und löse Aufgaben direkt in der App."
            : "Choose a language and solve exercises directly in the app."
    }

    var body: some View {
        ScrollView {
            switch loadState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 300)
            case .failed(let details):
                ContentLoadingFailureView(
                    title: localization.text.common.loadErrorTitle,
                    description: localization.text.common.loadErrorDescription,
                    details: details
                )
                .padding()
            case .loaded(let tasksByLanguage):
                VStack(alignment: .leading, spacing: 20) {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(ProgrammingLanguage.allCases) { language in
                            NavigationLink {
                                PracticeTaskListView(
                                    language: language,
                                    tasks: tasksByLanguage[language] ?? []
                                )
                            } label: {
                                PracticeLanguageCard(
                                    language: language,
                                    taskCount: tasksByLanguage[language]?.count
                                        ?? 0,
                                    taskLabel: localization.text.learningMode
                                        .tasks
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.inline)
        .task {
            loadTasks()
        }
    }

    private func loadTasks() {
        do {
            loadState = .loaded(
                try Dictionary(
                    uniqueKeysWithValues: ProgrammingLanguage.allCases.map {
                        ($0, try CodingTaskLoader.shared.loadTasks(for: $0))
                    }
                )
            )
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }
}

private struct PracticeLanguageCard: View {
    let language: ProgrammingLanguage
    let taskCount: Int
    let taskLabel: String

    var body: some View {
        let style = CategoryStyle.style(for: language.topicCategory)

        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: language.icon)
                .font(.title2)
                .foregroundStyle(style.color)
                .frame(width: 44, height: 44)
                .background(style.color.opacity(0.12))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )

            Text(language.title)
                .font(.headline)

            Label("\(taskCount) \(taskLabel)", systemImage: "keyboard")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
        }
    }
}

private struct PracticeTaskListView: View {
    let language: ProgrammingLanguage
    let tasks: [CodingTask]

    @Environment(LocalizationStore.self) private var localization

    var body: some View {
        List(tasks) { task in
            NavigationLink {
                CodeChallengeView(task: task)
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    Text(task.title(language: localization.language))
                        .font(.headline)

                    Text(task.instruction(language: localization.language))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(language.title)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    PreviewRoot {
        NavigationStack {
            PracticeView()
        }
    }
}
