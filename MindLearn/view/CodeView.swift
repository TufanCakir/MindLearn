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
    @State private var highlightedPreview = AttributedString("")
    @State private var showCopied = false
    @State private var showsFullCode = false
    @State private var copyFeedbackTask: Task<Void, Never>?
    @AppStorage("codeWrapLongLines") private var wrapsLongLines = true
    @AppStorage("codeFontSize") private var codeFontSize = 16.0
    @Environment(LocalizationStore.self) private var localization

    private var appLanguage: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    private var codeLabel: String {
        "\(text.common.codeExample), \(language.displayName)"
    }

    private var codeLines: [Substring] {
        code.split(separator: "\n", omittingEmptySubsequences: false)
    }

    private var previewCode: String {
        codeLines.prefix(12).joined(separator: "\n")
    }

    private var hasMoreCode: Bool {
        codeLines.count > 12
    }

    private var openCodeTitle: String {
        appLanguage == "de" ? "Vollständig öffnen" : "Open full code"
    }

    private var closeTitle: String {
        appLanguage == "de" ? "Schließen" : "Close"
    }

    private var lineCountTitle: String {
        appLanguage == "de"
            ? "\(codeLines.count) Zeilen"
            : "\(codeLines.count) lines"
    }

    private var displayTitle: String {
        appLanguage == "de" ? "Darstellung" : "Display"
    }

    private var wrapTitle: String {
        appLanguage == "de" ? "Zeilenumbruch" : "Wrap lines"
    }

    private var smallerTextTitle: String {
        appLanguage == "de" ? "Kleinere Schrift" : "Smaller text"
    }

    private var largerTextTitle: String {
        appLanguage == "de" ? "Größere Schrift" : "Larger text"
    }

    var body: some View {

        VStack(spacing: 0) {

            header

            codeScroll(highlightedPreview)
                .frame(maxHeight: 270)

            if hasMoreCode {
                Button {
                    showsFullCode = true
                } label: {
                    HStack {
                        Label(
                            openCodeTitle,
                            systemImage: "arrow.up.left.and.arrow.down.right"
                        )
                        Spacer()
                        Text(lineCountTitle)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .overlay(alignment: .top) {
                    Divider()
                }
            }
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
        .sheet(isPresented: $showsFullCode) {
            NavigationStack {
                fullCodeScroll(highlighted)
                    .background(Color(.systemGroupedBackground))
                    .navigationTitle(language.displayName)
                    .toolbarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(closeTitle) {
                                showsFullCode = false
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                copyCode()
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .accessibilityLabel(text.common.copy)
                        }

                        ToolbarItem(placement: .primaryAction) {
                            codeDisplayMenu
                        }
                    }
            }
        }
        .task(id: code) {
            async let fullCode = SyntaxHighlighter.shared.highlight(code)
            async let preview = SyntaxHighlighter.shared.highlight(previewCode)
            highlighted = await fullCode
            highlightedPreview = await preview
        }
        .onDisappear {
            copyFeedbackTask?.cancel()
        }
    }
}

extension CodeView {
    private func codeScroll(_ content: AttributedString) -> some View {
        ScrollView(.horizontal) {
            codeText(content)
        }
        .scrollIndicators(.visible)
    }

    @ViewBuilder
    private func fullCodeScroll(_ content: AttributedString) -> some View {
        if wrapsLongLines {
            ScrollView(.vertical) {
                fullCodeText(content)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .scrollIndicators(.visible)
        } else {
            ScrollView([.horizontal, .vertical]) {
                fullCodeText(content)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .scrollIndicators(.visible)
        }
    }

    private func codeText(_ content: AttributedString) -> some View {
        Text(content)
            .font(.system(.callout, design: .monospaced))
            .textSelection(.enabled)
            .copyable([code])
            .accessibilityLabel(codeLabel)
            .padding(16)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }

    private func fullCodeText(_ content: AttributedString) -> some View {
        Text(content)
            .font(.system(size: codeFontSize, design: .monospaced))
            .multilineTextAlignment(.leading)
            .textSelection(.enabled)
            .copyable([code])
            .accessibilityLabel(codeLabel)
            .padding(16)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }

    private var codeDisplayMenu: some View {
        Menu {
            Button {
                codeFontSize = max(12, codeFontSize - 1)
            } label: {
                Label(smallerTextTitle, systemImage: "textformat.size.smaller")
            }
            .disabled(codeFontSize <= 12)

            Button {
                codeFontSize = min(24, codeFontSize + 1)
            } label: {
                Label(largerTextTitle, systemImage: "textformat.size.larger")
            }
            .disabled(codeFontSize >= 24)

            Divider()

            Toggle(isOn: $wrapsLongLines) {
                Label(wrapTitle, systemImage: "arrow.turn.down.right")
            }
        } label: {
            Image(systemName: "textformat.size")
        }
        .accessibilityLabel(displayTitle)
    }

    private func copyCode() {
        UIPasteboard.general.string = code

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
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
                copyCode()
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
