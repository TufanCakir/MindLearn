//
//  DrawerDetailView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct DrawerDetailView: View {

    let section: DrawerSection

    @Environment(\.colorScheme) private var colorScheme
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    private var localizedTitle: String {
        section.title(language: language)
    }

    private var localizedDescription: String {
        section.description(language: language)
    }

    private var localizedSteps: [String] {
        section.steps(language: language)
    }

    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var maxWidth: CGFloat {
        isPad ? 720 : .infinity
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 32) {

                heroHeader

                descriptionSection

                stepsSection

                codeSection

                Spacer(minLength: 30)
            }
            .frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
        }
        .background(background)
        .navigationTitle(localizedTitle)
        .toolbarTitleDisplayMode(.inline)
    }
}

//
// MARK: Background
//

extension DrawerDetailView {

    private var background: some View {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }
}

//
// MARK: Hero ⭐ verbessert
//

extension DrawerDetailView {

    private var heroHeader: some View {

        ZStack(alignment: .bottomLeading) {

            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .fill(.ultraThinMaterial)

            VStack(alignment: .leading, spacing: 12) {

                Image(systemName: "doc.text")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.blue)
                    .accessibilityHidden(true)

                Text(localizedTitle)
                    .font(.system(.title, design: .rounded).bold())
                    .multilineTextAlignment(.leading)
                    .accessibilityAddTraits(.isHeader)
            }
            .padding(24)
        }
        .frame(height: isPad ? 220 : 180)
        .shadow(
            color: .black.opacity(0.15),
            radius: 12,
            y: 6
        )
        .padding(.horizontal)
    }
}

//
// MARK: Description
//

extension DrawerDetailView {

    @ViewBuilder
    private var descriptionSection: some View {

        if !localizedDescription.isEmpty {

            VStack(alignment: .leading, spacing: 10) {

                Text(text.detail.description)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                Text(localizedDescription)
                    .font(.body)
                    .lineSpacing(5)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
    }
}

//
// MARK: Steps ⭐ modernisiert
//

extension DrawerDetailView {

    @ViewBuilder
    private var stepsSection: some View {

        if !localizedSteps.isEmpty {

            VStack(alignment: .leading, spacing: 18) {

                Text(text.detail.steps)
                    .font(.headline)
                    .padding(.horizontal)
                    .accessibilityAddTraits(.isHeader)

                ForEach(Array(localizedSteps.enumerated()), id: \.offset) {
                    index,
                    step in

                    HStack(alignment: .top, spacing: 14) {

                        Text("\(index + 1)")
                            .font(.caption.bold())
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .fill(.blue.gradient)
                            )
                            .foregroundStyle(.white)

                        Text(step)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(18)
                    .accessibilityElement(children: .combine)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 18,
                            style: .continuous
                        )
                        .fill(Color(.secondarySystemGroupedBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
            }
        }
    }
}

//
// MARK: Code Section ⭐ cleaner
//

extension DrawerDetailView {

    private var codeSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text(text.detail.codeExample)
                .font(.headline)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)

            CodeView(code: section.code)
                .frame(maxWidth: maxWidth)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                )
                .padding(.horizontal)
        }
    }
}
