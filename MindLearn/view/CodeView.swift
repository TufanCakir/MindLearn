//
//  CodeView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct CodeView: View {

    let code: String

    @State private var highlighted = AttributedString("")
    @State private var showCopied = false

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            header

            ScrollView([.vertical, .horizontal]) {

                Text(highlighted)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .overlay(copyOverlay, alignment: .topTrailing)
        .task(id: code) {
            highlighted = await SyntaxHighlighter.shared.highlight(code)
        }
    }
}

// MARK: Header
extension CodeView {

    fileprivate var header: some View {

        HStack {

            Label(language.displayName, systemImage: language.icon)
                .font(.caption.bold())
                .foregroundStyle(.primary)

            Spacer()

            Button {
                UIPasteboard.general.string = code

                withAnimation(.spring()) { showCopied = true }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation { showCopied = false }
                }

            } label: {
                Label("Kopieren", systemImage: "doc.on.doc")
                    .font(.caption2.bold())
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.tertiarySystemGroupedBackground))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.separator)),
            alignment: .bottom
        )
    }
}

// MARK: Overlay
extension CodeView {

    fileprivate var copyOverlay: some View {

        Group {
            if showCopied {
                Label("Kopiert", systemImage: "checkmark.circle.fill")
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                    .cornerRadius(10)
                    .padding(10)
                    .transition(.scale.combined(with: .opacity))
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
