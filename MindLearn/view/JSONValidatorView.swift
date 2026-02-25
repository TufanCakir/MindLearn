//
//  JSONValidatorView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

import SwiftUI
import UIKit

struct JSONValidatorView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var input = ""
    @State private var showCopied = false
    @State private var showShare = false

    @FocusState private var isFocused: Bool

    // MARK: - Live Validation

    private var validation: JSONValidationResult {
        JSONTools.validate(input)
    }

    private var output: String {
        validation.normalizedOutput
    }

    var body: some View {

        VStack(spacing: 0) {

            header

            Divider()

            ScrollView {

                VStack(spacing: 18) {

                    inputSection

                    statusSection

                    outputSection

                    Spacer(minLength: 28)
                }
                .padding(.vertical, 16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
        )
        .toolbar { keyboardToolbar }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: [output])
        }
    }
}

// MARK: - Header

extension JSONValidatorView {

    private var header: some View {

        JSONActionHeader(
            onPaste: paste,
            onClear: { input = "" },
            onAutoFix: applyAutoFix,
            onPrettyPrint: prettyPrintToInput,
            onMinify: minifyToInput,
            primaryTitle: "Kopieren",
            primarySystemImage: "doc.on.doc",
            primaryEnabled: !output.isEmpty,
            onPrimary: copyOutput,
            secondaryTitle: "Teilen",
            secondarySystemImage: "square.and.arrow.up",
            secondaryEnabled: !output.isEmpty,
            onSecondary: { showShare = true }
        )
    }
}

// MARK: - Input

extension JSONValidatorView {

    private var inputSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label("Input JSON", systemImage: "curlybraces")
                .font(.headline)
                .foregroundStyle(.blue)

            ZStack(alignment: .topLeading) {

                if input.isEmpty {
                    Text("JSON hier einfügen …")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .font(.system(.body, design: .monospaced))
                }

                TextEditor(text: $input)
                    .focused($isFocused)
                    .font(.system(.body, design: .monospaced))
                    .padding(10)
                    .scrollContentBackground(.hidden)
                    .background(editorBackground)
                    .frame(minHeight: 190)
            }
        }
        .padding(.horizontal)
    }

    private var editorBackground: some View {

        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        isFocused ? .blue : Color(.separator),
                        lineWidth: isFocused ? 1.8 : 1
                    )
            )
    }
}

// MARK: - Status

extension JSONValidatorView {

    private var placeholderOutput: String {

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return "// Noch kein JSON eingefügt."
        }

        if output.isEmpty {
            return "// Keine gültige Ausgabe vorhanden."
        }

        return output
    }

    private var statusSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label("Status", systemImage: "checkmark.seal")
                .font(.headline)
                .foregroundStyle(.primary)

            HStack(alignment: .top, spacing: 12) {

                Image(
                    systemName: validation.isValid
                        ? "checkmark.circle.fill" : "xmark.octagon.fill"
                )
                .font(.title3)
                .foregroundStyle(validation.isValid ? .green : .red)

                VStack(alignment: .leading, spacing: 6) {

                    Text(
                        validation.isValid ? "Gültiges JSON" : "Ungültiges JSON"
                    )
                    .font(.headline)

                    if !validation.message.isEmpty {
                        Text(validation.message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let hint = validation.hint {
                        Text("Tipp: \(hint)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - Output

extension JSONValidatorView {

    private var outputSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Output (normalisiert)",
                systemImage: "doc.text.magnifyingglass"
            )
            .font(.headline)
            .foregroundStyle(.orange)

            ScrollView(.vertical) {
                ScrollView(.horizontal, showsIndicators: true) {
                    Text(placeholderOutput)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(
                            output.isEmpty ? .secondary : .primary
                        )
                        .foregroundColor(
                            !output.isEmpty
                                ? (colorScheme == .dark ? .white : .black)
                                : nil
                        )
                        .padding()
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(outputBackground)
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

// MARK: - Actions

extension JSONValidatorView {

    private func paste() {
        guard let text = UIPasteboard.general.string, !text.isEmpty else {
            return
        }
        input = text
    }

    private func applyAutoFix() {
        hideKeyboard()
        let fixed = JSONTools.autoFix(input)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            input = fixed
        }
    }

    private func prettyPrintToInput() {
        hideKeyboard()
        let result = JSONTools.prettyPrint(input)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            input = result
        }
    }

    private func minifyToInput() {
        hideKeyboard()
        let result = JSONTools.minify(input)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            input = result
        }
    }

    private func copyOutput() {
        guard !output.isEmpty else { return }
        UIPasteboard.general.string = output

        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            showCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut(duration: 0.2)) {
                showCopied = false
            }
        }
    }

    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Fertig") { hideKeyboard() }
                .font(.headline)
        }
    }
}

#Preview {
    JSONValidatorView()
        .preferredColorScheme(.dark)
}
