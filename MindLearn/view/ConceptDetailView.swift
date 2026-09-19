//
//  ConceptDetailView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct ConceptDetailView: View {
    let concept: LearningConcept

    @Environment(LocalizationStore.self) private var localization

    private var appLanguage: String { localization.language }

    @State private var playgroundCode: String

    private var text: AppLocalization {
        localization.text
    }

    init(concept: LearningConcept) {
        self.concept = concept
        _playgroundCode = State(initialValue: concept.playgroundCode)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                symbolSection
                explanationSection
                exampleSection
                playgroundSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(concept.title(language: appLanguage))
        .toolbarTitleDisplayMode(.inline)
    }
}

extension ConceptDetailView {
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(concept.language.rawValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(concept.title(language: appLanguage))
                .font(.title2.bold())

            Text(concept.summary(language: appLanguage))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var symbolSection: some View {
        if !concept.symbols.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(text.concepts.symbols)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                FlowLayout(spacing: 8) {
                    ForEach(concept.symbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.callout.monospaced().weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(
                                Color(.secondarySystemGroupedBackground)
                            )
                            .clipShape(Capsule(style: .continuous))
                    }
                }
            }
        }
    }

    private var explanationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(text.common.description)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            Text(concept.explanation(language: appLanguage))
                .font(.body)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var exampleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(text.concepts.example)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            CodeView(code: concept.exampleCode)
        }
    }

    private var playgroundSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(text.concepts.playground)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                Button(text.concepts.reset) {
                    playgroundCode = concept.playgroundCode
                }
                .buttonStyle(.bordered)
            }

            TextEditor(text: $playgroundCode)
                .font(.system(.body, design: .monospaced))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(10)
                .frame(minHeight: 180)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
                )
                .accessibilityLabel(text.concepts.playground)
        }
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var size = CGSize.zero
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)

            if rowWidth + subviewSize.width > maxWidth && rowWidth > 0 {
                size.width = max(size.width, rowWidth)
                size.height += rowHeight + spacing
                rowWidth = 0
                rowHeight = 0
            }

            rowWidth += (rowWidth == 0 ? 0 : spacing) + subviewSize.width
            rowHeight = max(rowHeight, subviewSize.height)
        }

        size.width = max(size.width, rowWidth)
        size.height += rowHeight

        return size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        var point = bounds.origin
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if point.x + size.width > bounds.maxX && point.x > bounds.minX {
                point.x = bounds.minX
                point.y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: point,
                proposal: ProposedViewSize(size)
            )

            point.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
