//
//  LearningCard.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct LearningCard: View {

    let topic: LearningTopic

    // MARK: Storage

    @AppStorage("favoriteIDs")
    private var favoriteIDs = ""

    @State private var showShareSheet = false
    @State private var isPressed = false

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    // MARK: Favorites Cache

    private var favorites: Set<String> {

        Set(
            favoriteIDs
                .split(separator: ",")
                .map(String.init)
        )
    }

    // MARK: Body

    var body: some View {

        ZStack(alignment: .topTrailing) {

            background

            if let icon = topic.icon {

                Text(icon)
                    .font(.system(size: iconSize))
                    .padding(14)
                    .opacity(0.9)
            }

            content

        }
        .frame(height: cardHeight)

        .scaleEffect(
            isPressed ? 0.97 : 1
        )

        .animation(
            .spring(
                response: 0.35,
                dampingFraction: 0.7
            ),
            value: isPressed
        )

        .scaleEffect(isPressed ? 0.97 : 1)

        .sheet(isPresented: $showShareSheet) {

            ShareSheet(
                activityItems: [
                    topic.code
                ]
            )
        }
    }
}

// MARK: Content

extension LearningCard {

    fileprivate var content: some View {

        VStack(alignment: .leading) {

            Spacer(minLength: 0)

            Text(topic.title)

                .font(titleFont)

                .lineLimit(2)

            Text(topic.description)

                .font(descriptionFont)

                .foregroundStyle(.primary)

                .lineLimit(2)

            HStack {

                Spacer()

                shareButton

            }

        }
        .padding(16)
    }
}

// MARK: Background
extension LearningCard {

    fileprivate var background: some View {

        RoundedRectangle(
            cornerRadius: 20,
            style: .continuous
        )
        .fill(Color(.secondarySystemGroupedBackground))

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

        .shadow(
            color: .black.opacity(0.12),
            radius: 8,
            y: 4
        )
    }

    fileprivate var shareButton: some View {

        Button {

            showShareSheet = true

        } label: {

            Image(
                systemName:
                    "square.and.arrow.up"
            )
            .font(actionFont)
        }
        .buttonStyle(.plain)
    }
}

// MARK: Layout

extension LearningCard {

    fileprivate var cardHeight: CGFloat {

        sizeClass == .regular
            ? 240
            : 205
    }

    fileprivate var iconSize: CGFloat {

        sizeClass == .regular
            ? 42
            : 32
    }

    fileprivate var titleFont: Font {

        sizeClass == .regular
            ? .title3.bold()
            : .headline.bold()
    }

    fileprivate var descriptionFont: Font {

        sizeClass == .regular
            ? .subheadline
            : .caption
    }

    fileprivate var actionFont: Font {

        sizeClass == .regular
            ? .footnote.bold()
            : .caption.bold()
    }
}

// MARK: Favorites

extension LearningCard {

    fileprivate func toggleFavorite() {

        var set = favorites

        if set.contains(topic.id) {

            set.remove(topic.id)

        } else {

            set.insert(topic.id)
        }

        favoriteIDs =
            set.sorted().joined(separator: ",")
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
