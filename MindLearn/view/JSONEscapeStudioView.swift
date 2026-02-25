//
//  JSONEscapeStudioView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct JSONEscapeStudioView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var inputText = ""
    @State private var isUnescapeMode = false
    @State private var showCopied = false

    @FocusState private var isEditorFocused: Bool

    private var outputText: String {
        isUnescapeMode
            ? unescapeFromJSON(inputText)
            : escapeForJSON(inputText)
    }

    var body: some View {

        VStack(spacing: 0) {

            headerControls

            Divider()

            ScrollView {

                VStack(spacing: 18) {

                    inputSection

                    outputSection

                    Spacer(minLength: 28)
                }
                .padding(.vertical, 16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .toolbar { keyboardToolbar }
        .onTapGesture { hideKeyboard() }
    }
}

// MARK: - Header controls (sticky)

extension JSONEscapeStudioView {

    private var headerControls: some View {

        JSONActionHeader(
            modeTitle: "Modus",
            modeSelection: $isUnescapeMode,
            modeFalseTitle: "Escape → JSON",
            modeTrueTitle: "Unescape → Klartext",
            onPaste: pasteInput,
            onClear: { inputText = "" },
            onSwap: swapOutputToInput,
            primaryTitle: "Kopieren",
            primarySystemImage: "doc.on.doc",
            primaryEnabled: !outputText.isEmpty,
            onPrimary: copyOutput
        )
    }
}

// MARK: - Input

extension JSONEscapeStudioView {

    private var inputSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                isUnescapeMode ? "Escaped JSON" : "Original",
                systemImage: "doc.text.fill"
            )
            .font(.headline)
            .foregroundStyle(.blue)

            ZStack(alignment: .topLeading) {

                if inputText.isEmpty {
                    Text("Hier Code einfügen oder schreiben …")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .font(.system(.body, design: .monospaced))
                }

                TextEditor(text: $inputText)
                    .focused($isEditorFocused)
                    .font(.system(.body, design: .monospaced))
                    .padding(10)
                    .scrollContentBackground(.hidden)
                    .background(editorBackground)
                    .frame(minHeight: 170)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Output

extension JSONEscapeStudioView {

    private var outputSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                isUnescapeMode ? "Klartext" : "Escaped JSON",
                systemImage: "chevron.left.forwardslash.chevron.right"
            )
            .font(.headline)
            .foregroundStyle(.orange)

            // Horizontal + vertical scroll (wie CodeView)
            ScrollView(.vertical) {

                ScrollView(.horizontal, showsIndicators: true) {

                    Text(placeholderOutput)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(
                            outputText.isEmpty ? .secondary : .primary
                        )
                        .foregroundColor(
                            !outputText.isEmpty
                                ? (colorScheme == .dark ? .white : .black)
                                : nil
                        )
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(outputBackground)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14,
                                style: .continuous
                            )
                        )
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 14,
                                style: .continuous
                            )
                            .stroke(Color(.separator), lineWidth: 1)
                        )
                }
            }
            .frame(minHeight: 210)
            .overlay(alignment: .topTrailing) { copiedToast }
        }
        .padding(.horizontal)
    }

    private var copiedToast: some View {

        Group {
            if showCopied {
                Label("Kopiert", systemImage: "checkmark.circle.fill")
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .padding(10)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Background styles

extension JSONEscapeStudioView {

    private var editorBackground: some View {

        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        isEditorFocused ? .blue : Color(.separator),
                        lineWidth: isEditorFocused ? 1.8 : 1
                    )
            )
    }

    private var outputBackground: some View {

        LinearGradient(
            colors: colorScheme == .dark
                ? [
                    Color(.secondarySystemGroupedBackground),
                    Color(.tertiarySystemGroupedBackground),
                ]
                : [
                    Color(.systemBackground),
                    Color(.secondarySystemGroupedBackground),
                ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Toolbar

extension JSONEscapeStudioView {

    private var keyboardToolbar: some ToolbarContent {

        ToolbarItemGroup(placement: .keyboard) {

            Spacer()

            Button("Fertig") { hideKeyboard() }
                .font(.headline)
        }
    }
}

// MARK: - Actions

extension JSONEscapeStudioView {

    private var placeholderOutput: String {

        if inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "// Noch kein Text eingefügt."
        }

        if outputText.isEmpty {
            return "// Keine Ausgabe möglich."
        }

        return outputText
    }

    private func swapOutputToInput() {
        hideKeyboard()

        let previousOutput = outputText
        guard !previousOutput.isEmpty else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isUnescapeMode.toggle()
            inputText = previousOutput
        }
    }

    private func copyOutput() {
        guard !outputText.isEmpty else { return }
        UIPasteboard.general.string = outputText

        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            showCopied = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut(duration: 0.2)) {
                showCopied = false
            }
        }
    }

    private func pasteInput() {

        guard let text = UIPasteboard.general.string, !text.isEmpty else {
            return
        }
        inputText = text
    }
}

// MARK: - Escape Helpers (robuster)

func escapeForJSON(_ text: String) -> String {

    text
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\"", with: "\\\"")
        .replacingOccurrences(of: "\r", with: "\\r")
        .replacingOccurrences(of: "\n", with: "\\n")
        .replacingOccurrences(of: "\t", with: "\\t")
}

func unescapeFromJSON(_ text: String) -> String {

    // Wichtig: erst \\\" und \\r \\n \\t, dann \\\\
    text
        .replacingOccurrences(of: "\\r", with: "\r")
        .replacingOccurrences(of: "\\n", with: "\n")
        .replacingOccurrences(of: "\\t", with: "\t")
        .replacingOccurrences(of: "\\\"", with: "\"")
        .replacingOccurrences(of: "\\\\", with: "\\")
}

#Preview {
    JSONEscapeStudioView()
        .preferredColorScheme(.dark)
}
