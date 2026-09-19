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

            VStack(spacing: 28) {

                heroHeader

                progressSection

                descriptionSection

                stepsSection

                codeSection

                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
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

//
// MARK: HERO HEADER
//

extension LearningDetailView {

    private var heroHeader: some View {

        ZStack(alignment: .bottomLeading) {

            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .fill(.ultraThinMaterial)

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.15),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )

            VStack(alignment: .leading, spacing: 8) {

                Text(localizedTitle)
                    .font(
                        .system(
                            .title,
                            design: .rounded
                        )
                        .weight(.bold)
                    )
                    .accessibilityAddTraits(.isHeader)
            }
            .frame(
                maxWidth: contentWidth
            )
            .frame(height: isPad ? 220 : 180)
            .padding(.horizontal)
            .shadow(
                color: .black.opacity(0.12),
                radius: 12,
                y: 8
            )
        }
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
        VStack(alignment: .leading, spacing: 14) {
            Text(text.progress.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: 10) {
                progressButton(.read, title: text.progress.markRead)
                progressButton(.understood, title: text.progress.markUnderstood)
                progressButton(.review, title: text.progress.markReview)
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
            .frame(maxWidth: .infinity)
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

            VStack(alignment: .leading, spacing: 10) {

                Text(text.detail.description)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                Text(localizedDescription)
                    .font(.body)
                    .lineSpacing(6)
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

            VStack(
                alignment: .leading,
                spacing: 16
            ) {

                Text(text.detail.steps)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                VStack(spacing: 14) {

                    ForEach(
                        Array(localizedSteps.enumerated()),
                        id: \.offset
                    ) { index, step in

                        HStack(
                            alignment: .top,
                            spacing: 16
                        ) {

                            stepNumber(index + 1)

                            Text(step)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }
                        .padding(18)
                        .accessibilityElement(children: .combine)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 18,
                                style: .continuous
                            )
                            .fill(
                                Color(
                                    .secondarySystemGroupedBackground
                                )
                            )
                        )
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
            .font(.caption.bold())
            .frame(width: 30, height: 30)
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
            .frame(
                maxWidth: width,
                alignment: .leading
            )
            .padding(.horizontal)
            .padding(18)
            .background(

                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .fill(
                    Color(
                        .secondarySystemGroupedBackground
                    )
                )
            )
            .overlay(

                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .stroke(
                    Color(.separator),
                    lineWidth: 1
                )
            )
    }
}
