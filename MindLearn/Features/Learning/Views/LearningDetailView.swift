//
//  LearningDetailView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

struct LearningDetailView: View {

    let topic: LearningTopic
    @Environment(\.modelContext) private var modelContext
    @Query private var progressRecords: [LearningProgress]
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    private var localizedTitle: String {
        topic.title(language: language)
    }

    private var localizedDescription: String {
        topic.description(language: language)
    }

    private var localizedSteps: [String] {
        topic.steps(language: language)
    }

    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var contentWidth: CGFloat {
        isPad ? 720 : .infinity
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 12) {
                progressSection
                descriptionSection
                stepsSection
                codeSection
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.bottom, 40)
        }
        .background(background)
        .navigationTitle(localizedTitle)
        .toolbarTitleDisplayMode(.inline)
        .onAppear(perform: recordOpened)
    }
}

// MARK: Background

extension LearningDetailView {

    private var background: some View {

        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }
}

// MARK: Progress

extension LearningDetailView {
    private var currentProgress: LearningProgress? {
        progressRecords.first { $0.topicID == topic.id }
    }

    private var currentStatus: LearningProgressStatus {
        currentProgress?.status ?? .unread
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(text.progress.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    progressButton(.read, title: text.progress.markRead)
                        .fixedSize(horizontal: true, vertical: false)
                    progressButton(
                        .understood,
                        title: text.progress.markUnderstood
                    )
                    .fixedSize(horizontal: true, vertical: false)
                    progressButton(.review, title: text.progress.markReview)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 8) {
                    progressButton(.read, title: text.progress.markRead)
                    progressButton(
                        .understood,
                        title: text.progress.markUnderstood
                    )
                    progressButton(.review, title: text.progress.markReview)
                }
            }

            progressMetadata
        }
        .sectionCard(width: contentWidth)
    }

    private func progressButton(
        _ status: LearningProgressStatus,
        title: String
    ) -> some View {
        Group {
            if currentStatus == status {
                Button {
                    updateProgress(status)
                } label: {
                    progressButtonLabel(status, title: title)
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button {
                    updateProgress(status)
                } label: {
                    progressButtonLabel(status, title: title)
                }
                .buttonStyle(.bordered)
            }
        }
        .tint(status.color)
        .accessibilityValue(currentStatus == status ? text.progress.title : "")
    }

    private func progressButtonLabel(
        _ status: LearningProgressStatus,
        title: String
    ) -> some View {
        Label(title, systemImage: status.systemImage)
            .font(.caption.bold())
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
            .layoutPriority(status == .understood ? 1 : 0)
    }

    @ViewBuilder
    private var progressMetadata: some View {
        if let progress = currentProgress {
            VStack(alignment: .leading, spacing: 6) {
                if let lastOpenedAt = progress.lastOpenedAt {
                    Label(
                        "\(text.progress.lastOpened): \(lastOpenedAt.formatted(date: .abbreviated, time: .shortened))",
                        systemImage: "clock"
                    )
                }

                if let nextReviewAt = progress.nextReviewAt {
                    Label(
                        "\(text.progress.nextReview): \(nextReviewAt.formatted(date: .abbreviated, time: .omitted))",
                        systemImage: "calendar.badge.clock"
                    )
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }

    private func recordOpened() {
        let progress = progressForCurrentTopic()
        progress.lastOpenedAt = .now
        saveProgress()
    }

    private func updateProgress(_ status: LearningProgressStatus) {
        let progress = progressForCurrentTopic()
        progress.status = status
        progress.lastOpenedAt = .now

        switch status {
        case .unread:
            progress.completedAt = nil
            progress.nextReviewAt = nil
        case .read:
            progress.nextReviewAt = Calendar.current.date(
                byAdding: .day,
                value: 3,
                to: .now
            )
        case .understood:
            progress.completedAt = .now
            progress.reviewCount += 1
            progress.nextReviewAt = Calendar.current.date(
                byAdding: .day,
                value: 7,
                to: .now
            )
        case .review:
            progress.reviewCount += 1
            progress.nextReviewAt = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: .now
            )
        }

        saveProgress()
    }

    private func progressForCurrentTopic() -> LearningProgress {
        if let progress = currentProgress {
            return progress
        }

        let progress = LearningProgress(topicID: topic.id, lastOpenedAt: .now)
        modelContext.insert(progress)
        return progress
    }

    private func saveProgress() {
        try? modelContext.save()
    }
}

//
// MARK: DESCRIPTION
//

extension LearningDetailView {

    @ViewBuilder
    private var descriptionSection: some View {

        if !localizedDescription.isEmpty {

            VStack(alignment: .leading, spacing: 8) {
                Text(text.detail.description)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                Text(localizedDescription)
                    .font(.body)
                    .lineSpacing(3)
            }
            .sectionCard(width: contentWidth)
        }
    }
}

//
// MARK: STEPS
//

extension LearningDetailView {

    @ViewBuilder
    private var stepsSection: some View {

        if !localizedSteps.isEmpty {

            VStack(alignment: .leading, spacing: 10) {
                Text(text.detail.steps)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                VStack(spacing: 0) {
                    ForEach(
                        Array(localizedSteps.enumerated()),
                        id: \.offset
                    ) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            stepNumber(index + 1)

                            Text(step)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 10)
                        .accessibilityElement(children: .combine)

                        if index < localizedSteps.count - 1 {
                            Divider()
                                .padding(.leading, 36)
                        }
                    }
                }
            }
            .sectionCard(width: contentWidth)
        }
    }

    private func stepNumber(
        _ number: Int
    ) -> some View {

        Text("\(number)")
            .font(.caption2.bold())
            .frame(width: 24, height: 24)
            .background(
                Circle()
                    .fill(.blue.gradient)
            )
            .foregroundStyle(.white)
    }
}

//
// MARK: CODE
//

extension LearningDetailView {

    private var codeSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text(text.detail.codeExample)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            CodeView(
                code: topic.code
            )
        }
        .sectionCard(width: contentWidth)
    }
}

//
// MARK: Section Card Modifier ⭐
//

extension View {

    func sectionCard(
        width: CGFloat
    ) -> some View {

        self
            .padding(12)
            .frame(maxWidth: width, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            .padding(.horizontal, 16)
    }
}
