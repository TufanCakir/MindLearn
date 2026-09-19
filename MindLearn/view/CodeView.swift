//
//  CodeView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct CodeView: View {

    let code: String

    @State private var highlighted = AttributedString("")
    @State private var showCopied = false
    @State private var copyFeedbackTask: Task<Void, Never>?
    @Environment(LocalizationStore.self) private var localization

    private var appLanguage: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    private var codeLabel: String {
        "\(text.common.codeExample), \(language.displayName)"
    }

    var body: some View {

        VStack(spacing: 0) {

            header

            ScrollView(.vertical) {

                ScrollView(.horizontal, showsIndicators: true) {

                    Text(highlighted)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .copyable([code])
                        .accessibilityLabel(codeLabel)
                        .padding(18)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
            }
            .scrollIndicators(.visible)
        }
        .background(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .stroke(Color(.separator), lineWidth: 1)
        )
        .overlay(copyOverlay, alignment: .topTrailing)
        .task(id: code) {

            highlighted =
                await SyntaxHighlighter
                .shared
                .highlight(code)
        }
        .onDisappear {
            copyFeedbackTask?.cancel()
        }
    }
}

// MARK: Header
extension CodeView {

    fileprivate var header: some View {

        HStack {

            Label(
                language.displayName,
                systemImage: language.icon
            )
            .font(.caption.weight(.semibold))

            Spacer()

            Button {

                UIPasteboard.general.string = code

                withAnimation(
                    .spring(
                        response: 0.35,
                        dampingFraction: 0.7
                    )
                ) {

                    showCopied = true
                }

                copyFeedbackTask?.cancel()
                copyFeedbackTask = Task {
                    try? await Task.sleep(for: .seconds(1.3))
                    guard !Task.isCancelled else { return }
                    withAnimation(.easeOut) {
                        showCopied = false
                    }
                }

            } label: {

                Label(
                    text.common.copy,
                    systemImage: "doc.on.doc"
                )
                .font(.caption2.weight(.semibold))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(text.common.copy)
            .accessibilityHint(codeLabel)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {

            Divider()
        }
    }
}

// MARK: Overlay
extension CodeView {

    fileprivate var copyOverlay: some View {

        Group {

            if showCopied {

                Label(
                    text.common.copied,
                    systemImage: "checkmark.circle.fill"
                )
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(.thinMaterial)
                .clipShape(
                    Capsule(style: .continuous)
                )
                .shadow(radius: 5)
                .padding(12)
                .transition(
                    .move(edge: .top)
                        .combined(with: .opacity)
                )
            }
        }
    }
}

// MARK: Language

extension CodeView {

    fileprivate enum Language {

        case swift
        case html
        case react

        var displayName: String {

            switch self {

            case .swift: "Swift"
            case .html: "HTML"
            case .react: "React Native"

            }
        }

        var icon: String {

            switch self {

            case .swift: "swift"
            case .html:
                "chevron.left.forwardslash.chevron.right"

            case .react: "atom"
            }
        }
    }

    fileprivate var language: Language {

        let lower = code.lowercased()

        if lower.contains("<html")
            || lower.contains("</div>")
        {
            return .html
        }

        if lower.contains("usestate")
            || lower.contains("react")
        {
            return .react
        }

        return .swift
    }
}
