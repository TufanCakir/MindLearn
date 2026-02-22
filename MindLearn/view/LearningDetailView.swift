//
//  LearningDetailView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct LearningDetailView: View {

    let topic: LearningTopic

    private var isPad: Bool {

        UIDevice.current
            .userInterfaceIdiom == .pad
    }

    private var maxWidth: CGFloat {

        isPad ? 680 : .infinity
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                heroHeader

                descriptionSection

                stepsSection

                codeSection

            }
            .frame(
                maxWidth: .infinity
            )
            .padding(.bottom, 30)
        }

        .background(background)

        .navigationTitle(topic.title)

        .navigationBarTitleDisplayMode(.inline)
    }
}

extension LearningDetailView {

    fileprivate var background: some View {

        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }
}

extension LearningDetailView {

    fileprivate var heroHeader: some View {

        ZStack(alignment: .bottomLeading) {

            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            RoundedRectangle(
                cornerRadius: 22
            )
            .fill(.ultraThinMaterial)
            .opacity(0.25)

            VStack(alignment: .leading) {

                Spacer()

                Text(topic.title)

                    .font(
                        .system(
                            .title,
                            design: .rounded
                        )
                        .bold()
                    )

                    .shadow(radius: 6)

            }
            .padding()

        }
        .frame(height: isPad ? 260 : 200)

        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

        .shadow(
            color: .black.opacity(0.35),
            radius: 14,
            y: 8
        )

        .padding(.horizontal)
    }
}

extension LearningDetailView {

    @ViewBuilder
    fileprivate var descriptionSection: some View {

        if !topic.description.isEmpty {

            Text(topic.description)

                .font(.body)

                .lineSpacing(5)

                .frame(
                    maxWidth: maxWidth,
                    alignment: .leading
                )

                .padding(.horizontal)
        }
    }
}

extension LearningDetailView {

    @ViewBuilder
    fileprivate var stepsSection: some View {

        if !topic.steps.isEmpty {

            VStack(
                alignment: .leading,
                spacing: 14
            ) {

                Text("Schritte")

                    .font(.headline)

                    .padding(.horizontal)

                ForEach(

                    Array(
                        topic.steps.enumerated()
                    ),

                    id: \.offset

                ) { index, step in

                    HStack(alignment: .top) {

                        Text("\(index+1)")

                            .font(.caption.bold())

                            .frame(
                                width: 26,
                                height: 26
                            )

                            .background(
                                Circle()
                                    .fill(
                                        Color.blue
                                    )
                            )

                        Text(step)

                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )

                    }

                    .padding()

                    .frame(
                        maxWidth: maxWidth,
                        alignment: .leading
                    )

                    .background(

                        RoundedRectangle(
                            cornerRadius: 14
                        )

                        .fill(
                            Color.white
                                .opacity(0.06)
                        )
                    )

                    .padding(.horizontal)
                }
            }
        }
    }
}

extension LearningDetailView {

    fileprivate var codeSection: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text("Code-Beispiel")

                .font(.headline)

                .padding(.horizontal)

            CodeView(
                code: topic.code
            )

            .frame(
                maxWidth: maxWidth
            )

            .clipShape(

                RoundedRectangle(
                    cornerRadius: 16
                )
            )

            .padding(.horizontal)
        }
    }
}
