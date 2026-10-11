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
    @State private var topicLoadState: ContentLoadState<[LearningTopic]> =
        .loading

    private var appLanguage: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    private var topics: [LearningTopic] {
        guard case .loaded(let topics) = topicLoadState else { return [] }
        return topics
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
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
            let topics = try LearningTopicLoader.shared.loadAllTopics().filter {
                $0.category == language.topicCategory
            }
            topicLoadState = .loaded(topics)
        } catch {
            topicLoadState = .failed(error.localizedDescription)
        }
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
