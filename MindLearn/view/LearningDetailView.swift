//
//  LearningDetailView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct LearningDetailView: View {

    let topic: LearningTopic

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

                descriptionSection

                stepsSection

                codeSection

                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
        }
        .background(background)
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
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

                Text(topic.title)
                    .font(
                        .system(
                            .title,
                            design: .rounded
                        )
                        .weight(.bold)
                    )
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

//
// MARK: DESCRIPTION
//

extension LearningDetailView {

    @ViewBuilder
    private var descriptionSection: some View {

        if !topic.description.isEmpty {

            VStack(alignment: .leading, spacing: 10) {

                Text("Beschreibung")
                    .font(.headline)

                Text(topic.description)
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

        if !topic.steps.isEmpty {

            VStack(
                alignment: .leading,
                spacing: 16
            ) {

                Text("Schritte")
                    .font(.headline)

                VStack(spacing: 14) {

                    ForEach(
                        Array(topic.steps.enumerated()),
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

            Text("Code-Beispiel")
                .font(.headline)

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
