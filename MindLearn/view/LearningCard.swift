//
//  LearningCard.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct LearningCard: View {

    let topic: LearningTopic
    let progressStatus: LearningProgressStatus

    init(topic: LearningTopic, progressStatus: LearningProgressStatus = .unread)
    {
        self.topic = topic
        self.progressStatus = progressStatus
    }

    @ObservedObject private var favoritesStore = FavoritesStore.shared
    @State private var showShareSheet = false

    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @AppStorage("enhancedAccessibilityLabels")
    private var enhancedAccessibilityLabels = true

    @AppStorage("reduceAppMotion")
    private var reduceAppMotion = false

    @AppStorage("largeLearningCards")
    private var largeLearningCards = false

    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    private var localizedTitle: String {
        topic.title(language: language)
    }

    private var localizedDescription: String {
        topic.description(language: language)
    }

    private var shouldReduceMotion: Bool {
        reduceMotion || reduceAppMotion
    }

    var body: some View {
        ZStack {
            background
            content
        }
        .frame(minHeight: cardHeight)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(cardAccessibilityLabel)
        .accessibilityHint(text.accessibility.learningCardHint)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [topic.code])
        }
    }
}

struct PressableCardStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("reduceAppMotion")
    private var reduceAppMotion = false

    private var shouldReduceMotion: Bool {
        reduceMotion || reduceAppMotion
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(
                shouldReduceMotion ? 1 : (configuration.isPressed ? 0.985 : 1)
            )
            .animation(
                shouldReduceMotion ? nil : .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}

//
// MARK: CONTENT
//

extension LearningCard {

    private var content: some View {
        return VStack(alignment: .leading, spacing: 14) {
            headerRow
            Spacer()
            Text(localizedTitle)
                .font(titleFont)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? 4 : 2)
                .accessibilityAddTraits(.isHeader)
            Text(localizedDescription)
                .font(descriptionFont)
                .foregroundStyle(.secondary)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 2)
            footerRow
        }
        .padding(18)
    }
}

//
// MARK: HEADER
//

extension LearningCard {

    private var headerRow: some View {
        return HStack {
            iconBadge
            progressBadge
            Spacer()
            favoriteButton
        }
    }

    private var iconBadge: some View {
        // ⭐ Category Mapping
        let style =
            CategoryStyle.style(
                for: topic.category
            )

        // ⭐ optional Override falls icon existiert
        let icon =
            topic.icon ?? style.icon

        return VStack {
            Image(systemName: icon)
                .font(
                    .system(
                        size: iconSize,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    style.color
                )
        }
        .symbolRenderingMode(.hierarchical)
        .padding(12)
        .frame(minWidth: 44, minHeight: 44)
        .background(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
            .fill(
                style.color.opacity(0.15)
            )
        )
    }
}

extension LearningCard {
    @ViewBuilder
    private var progressBadge: some View {
        if progressStatus != .unread {
            Label(
                progressTitle(for: progressStatus),
                systemImage: progressStatus.systemImage
            )
            .font(.caption2.bold())
            .foregroundStyle(progressStatus.color)
            .labelStyle(.iconOnly)
            .frame(minWidth: 32, minHeight: 32)
            .background(progressStatus.color.opacity(0.12))
            .clipShape(Circle())
            .accessibilityLabel(progressTitle(for: progressStatus))
        }
    }
}

//
// MARK: FAVORITE
//

extension LearningCard {

    private var favoriteButton: some View {
        let isFavorite =
            favoritesStore.favorites.contains(topic.id)

        return Button {
            if shouldReduceMotion {
                favoritesStore.toggle(id: topic.id)
            } else {
                withAnimation(
                    .spring(
                        response: 0.35,
                        dampingFraction: 0.6
                    )
                ) {
                    favoritesStore.toggle(id: topic.id)
                }
            }
        } label: {
            Image(
                systemName:
                    isFavorite
                    ? "star.fill"
                    : "star"
            )
            .font(.headline)
            .foregroundStyle(
                isFavorite
                    ? .yellow
                    : .secondary
            )
            .padding(10)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(Circle())
            .frame(minWidth: 44, minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            isFavorite
                ? text.accessibility.removeFavorite
                : text.accessibility.addFavorite
        )
        .accessibilityHint(text.accessibility.favoriteHint)
    }
}

//
// MARK: FOOTER
//

extension LearningCard {

    private var footerRow: some View {
        return HStack {
            Spacer()
            Button {
                showShareSheet = true
            } label: {
                Label(
                    text.common.share,
                    systemImage:
                        "square.and.arrow.up"
                )
                .font(actionFont)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel(text.accessibility.shareCode)
        }
    }
}

//
// MARK: BACKGROUND ⭐
//

extension LearningCard {

    private var background: some View {
        return RoundedRectangle(
            cornerRadius: 16,
            style: .continuous
        )
        .fill(Color(.secondarySystemGroupedBackground))
        .overlay(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .stroke(
                Color(.separator).opacity(0.45),
                lineWidth: 1
            )
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: 4,
            y: 2
        )
    }
}

//
// MARK: LAYOUT
//

extension LearningCard {

    private var cardHeight: CGFloat {
        if dynamicTypeSize.isAccessibilitySize || largeLearningCards {
            return sizeClass == .regular ? 330 : 300
        }

        return sizeClass == .regular
            ? 250
            : 210
    }

    private var iconSize: CGFloat {

        sizeClass == .regular
            ? 34
            : 28
    }

    private var titleFont: Font {

        sizeClass == .regular
            ? .title3.bold()
            : .headline.bold()
    }

    private var descriptionFont: Font {

        sizeClass == .regular
            ? .subheadline
            : .caption
    }

    private var actionFont: Font {

        sizeClass == .regular
            ? .footnote.bold()
            : .caption.bold()
    }

    private var cardAccessibilityLabel: String {
        guard enhancedAccessibilityLabels else {
            return "\(localizedTitle). \(localizedDescription)"
        }

        let favorite =
            favoritesStore.favorites.contains(topic.id)
            ? text.accessibility.favoriteStatus
            : text.accessibility.notFavoriteStatus

        return """
            \(localizedTitle). \(localizedDescription). \
            \(text.accessibility.categoryPrefix): \(topic.category). \
            \(text.progress.title): \(progressTitle(for: progressStatus)). \
            \(favorite).
            """
    }

    private func progressTitle(for status: LearningProgressStatus) -> String {
        switch status {
        case .unread: text.progress.unread
        case .read: text.progress.read
        case .understood: text.progress.understood
        case .review: text.progress.review
        }
    }
}
// MARK: ShareSheet

struct ShareSheet:
    UIViewControllerRepresentable
{

    let activityItems: [Any]

    func makeUIViewController(
        context: Context
    ) -> UIActivityViewController {

        UIActivityViewController(

            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
