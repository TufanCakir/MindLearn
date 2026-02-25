//
//  OnboardingView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct OnboardingView: View {

    var onFinish: () -> Void

    @State private var page = 0

    var body: some View {

        ZStack {

            background

            VStack(spacing: 0) {

                TabView(selection: $page) {

                    // MARK: Page 1

                    OnboardingPage(

                        icon: .system("book"),

                        title: "MindLearn",

                        text:
                            """
                            Moderne Lernplattform für Entwickler,
                            Schüler und Lernende jeden Alters.

                            Klare Inhalte verbinden Theorie
                            mit praxisnahen Beispielen.
                            """
                    )
                    .tag(0)

                    // MARK: Page 2

                    OnboardingPage(

                        icon: .system("laptopcomputer"),

                        title: "Sprachen & Frameworks",

                        text:
                            """
                            Swift, SwiftUI, HTML, JSON,
                            ARKit, RealityKit, WidgetKit
                            und viele weitere Technologien.

                            Von Grundlagen bis Profi-Level.
                            """
                    )
                    .tag(1)

                    // MARK: Page 3

                    OnboardingPage(

                        icon: .system("graduationcap.fill"),

                        title: "Schule & Kinder Lernen",

                        text:
                            """
                            Mathematik, Sprache,
                            Lernstrategien und Programmieren.

                            Spielerisch lernen —
                            schnell verstehen.
                            """
                    )
                    .tag(2)

                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.smooth, value: page)

                bottomBar
            }
        }
    }
}

//
// MARK: - Background
//

extension OnboardingView {

    private var background: some View {

        LinearGradient(

            colors: [

                .blue.opacity(0.18),
                .purple.opacity(0.14),
                .pink.opacity(0.08),
                .clear,
            ],

            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

//
// MARK: - Bottom Button
//

extension OnboardingView {

    private var bottomBar: some View {

        VStack(spacing: 14) {

            Button(action: advance) {

                HStack {

                    Spacer()

                    Text(
                        page < 2
                            ? "Weiter"
                            : "Loslegen"
                    )
                    .fontWeight(.semibold)

                    Image(
                        systemName:

                            page < 2
                            ? "arrow.right"
                            : "checkmark"
                    )

                    Spacer()
                }
            }

            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            if page < 2 {

                Button("Überspringen") {

                    onFinish()

                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 24)

        .background(.ultraThinMaterial)
    }
}

//
// MARK: - Navigation
//

extension OnboardingView {

    private func advance() {

        if page < 2 {

            withAnimation(

                .spring(
                    response: 0.45,
                    dampingFraction: 0.85
                )
            ) {

                page += 1
            }

        } else {

            onFinish()
        }
    }
}
