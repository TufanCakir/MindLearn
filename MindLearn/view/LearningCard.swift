//
//  LearningCard.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct LearningCard: View {

    let topic: LearningTopic

    @ObservedObject private var favoritesStore = FavoritesStore.shared
    @State private var showShareSheet = false

    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ZStack {
            background
            content
        }
        .frame(height: cardHeight)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [topic.code])
        }
    }
}

struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(
                .spring(response: 0.35, dampingFraction: 0.75),
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
            Text(topic.title)
                .font(titleFont)
                .lineLimit(2)
            Text(topic.description)
                .font(descriptionFont)
                .foregroundStyle(.secondary)
                .lineLimit(2)
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

//
// MARK: FAVORITE
//

extension LearningCard {

    private var favoriteButton: some View {
        let isFavorite =
            favoritesStore.favorites.contains(topic.id)

        return Button {
            withAnimation(
                .spring(
                    response: 0.35,
                    dampingFraction: 0.6
                )
            ) {
                favoritesStore.toggle(id: topic.id)
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
            .background(.thinMaterial)
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
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
                    "Teilen",
                    systemImage:
                        "square.and.arrow.up"
                )
                .font(actionFont)
            }
            .buttonStyle(.bordered)
        }
    }
}

//
// MARK: BACKGROUND ⭐
//

extension LearningCard {

    private var background: some View {
        return RoundedRectangle(
            cornerRadius: 22,
            style: .continuous
        )
        .fill(
            LinearGradient(
                colors: [
                    Color(
                        .secondarySystemGroupedBackground
                    ),
                    Color(
                        .tertiarySystemGroupedBackground
                    ),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                Color(.separator),
                lineWidth: 1
            )
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 10,
            y: 6
        )
    }
}

//
// MARK: LAYOUT
//

extension LearningCard {

    private var cardHeight: CGFloat {

        sizeClass == .regular
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
