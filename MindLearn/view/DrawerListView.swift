//
//  DrawerListView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct DrawerListView: View {

    let sections: [DrawerSection]
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    var body: some View {
        Group {
            if sections.isEmpty {
                emptyState
            } else {
                content
            }
        }
    }
}

extension DrawerListView {

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(sections) { section in
                    NavigationLink {
                        DrawerDetailView(section: section)
                    } label: {
                        drawerCard(section)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(
                        "\(section.title(language: language)). \(section.description(language: language))"
                    )
                    .accessibilityHint(text.accessibility.learningCardHint)
                }
            }
            .padding(12)
        }
    }
}

extension DrawerListView {
    private func drawerCard(_ section: DrawerSection) -> some View {
        let style = CategoryStyle.style(for: section.category)
        let title = section.title(language: language)
        let description = section.description(language: language)

        return HStack(spacing: 12) {
            Image(systemName: style.icon)
                .font(.headline)
                .foregroundStyle(style.color)
                .frame(width: 36, height: 36)
                .accessibilityHidden(true)
                .background(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                    .fill(style.color.opacity(0.13))
                )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(12)
        .background(
            RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            )
            .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            )
            .stroke(
                Color(.separator).opacity(0.45),
                lineWidth: 1
            )
        )
    }
}

extension DrawerListView {

    private var emptyState: some View {
        ContentUnavailableView(
            text.drawer.emptyTitle,
            systemImage: "book.closed",
            description: Text(text.drawer.emptyDescription)
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}
