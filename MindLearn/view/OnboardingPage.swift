//
//  OnboardingPage.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

enum OnboardingIcon {
    case system(String)
    case asset(String)
}

struct OnboardingPage: View {

    private let iconSize: CGFloat = 72

    let icon: OnboardingIcon
    let title: String
    let text: String

    var body: some View {

        VStack {

            Spacer(minLength: 40)

            heroIcon

            VStack(spacing: 14) {

                Text(title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text(text)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 12)
            }
            .padding(.top, 12)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 26)
        .accessibilityElement(children: .contain)
    }
}

//
// MARK: - Hero Icon
//

extension OnboardingPage {

    private var heroIcon: some View {

        ZStack {

            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 140, height: 140)
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 20,
                    y: 8
                )

            iconImage
        }
        .padding(.bottom, 10)
        .accessibilityHidden(true)
    }

    private var iconImage: some View {

        Group {

            switch icon {

            case .system(let name):

                Image(systemName: name)
                    .font(
                        .system(
                            size: iconSize,
                            weight: .semibold
                        )
                    )

            case .asset(let name):

                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: iconSize,
                        height: iconSize
                    )
            }
        }
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.primary)
    }
}
