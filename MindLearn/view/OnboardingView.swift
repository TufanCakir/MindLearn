//
//  OnboardingView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct OnboardingView: View {

    var onFinish: () -> Void
    @State private var page = 0

    var body: some View {

        VStack {

            TabView(selection: $page) {

                // MARK: Page 1

                OnboardingPage(
                    icon: .asset("mindlearn_logo_dark"),
                    title: "MindLearn",
                    text:
                        """
                        MindLearn ist eine schnelle, saubere und moderne Lern-App.

                        Perfekt für Studenten, Schulen und Technik-Interessierte,
                        die Programmieren verstehen und neue Technologien lernen möchten.
                        """
                )
                .tag(0)

                // MARK: Page 2

                OnboardingPage(
                    icon: .system("laptopcomputer"),
                    title: "Viele Technologien",
                    text:
                        """
                        Lerne SwiftUI, HTML, JSON, ARKit,
                        SwiftData und viele weitere Frameworks.

                        Klare Beispiele und verständliche Schritte
                        helfen dir schneller zu lernen.
                        """
                )
                .tag(1)

                // MARK: Page 3

                OnboardingPage(
                    icon: .system("sparkles"),
                    title: "Modern Lernen",
                    text:
                        """
                        Sauberes Design, echte Code-Beispiele
                        und praxisnahe Projekte.

                        MindLearn hilft dir,
                        Programmieren einfacher zu verstehen
                        und direkt anzuwenden.
                        """
                )
                .tag(2)
            }

            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .animation(.easeInOut, value: page)

            Button(action: advance) {

                Text(
                    page < 2
                        ? "Weiter"
                        : "MindLearn starten"
                )

                .frame(maxWidth: .infinity)
            }

            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
        }

        .safeAreaInset(edge: .bottom) {

            Color.clear.frame(height: 8)
        }
    }

    private func advance() {

        if page < 2 {

            page += 1

        } else {

            onFinish()
        }
    }
}
