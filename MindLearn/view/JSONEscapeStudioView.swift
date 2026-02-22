//
//  JSONEscapeStudioView.swift
//  Slayken Learn
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

    // Output wird automatisch berechnet
    private var outputText: String {
        isUnescapeMode
            ? unescapeFromJSON(inputText)
            : escapeForJSON(inputText)
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    // MARK: Mode Picker
                    Picker("Modus", selection: $isUnescapeMode) {

                        Text("Escape → JSON").tag(false)
                        Text("Unescape → Klartext").tag(true)

                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // MARK: Input
                    VStack(alignment: .leading, spacing: 8) {

                        Label(
                            isUnescapeMode ? "Escaped JSON" : "Original Code",
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
                                .frame(minHeight: 160)

                        }

                        Button {

                            pasteInput()

                        } label: {

                            Label("Einfügen", systemImage: "doc.on.clipboard")
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.blue.opacity(0.15))
                                .cornerRadius(8)

                        }
                        .buttonStyle(.plain)

                    }
                    .padding(.horizontal)

                    // MARK: Output
                    VStack(alignment: .leading, spacing: 8) {

                        HStack {

                            Label(
                                isUnescapeMode ? "Klartext" : "Escaped JSON",
                                systemImage:
                                    "chevron.left.forwardslash.chevron.right"
                            )
                            .font(.headline)
                            .foregroundStyle(.orange)

                            Spacer()

                            Button(action: copyOutput) {

                                Label(
                                    "Kopieren",
                                    systemImage: "doc.on.doc.fill"
                                )
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.orange.opacity(0.15))
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }

                        ScrollView {

                            Text(
                                outputText.isEmpty
                                    ? "// Ausgabe erscheint hier …"
                                    : outputText
                            )
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(
                                colorScheme == .dark ? .white : .black
                            )
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(outputBackground)
                            .cornerRadius(12)
                            .shadow(
                                color: .black.opacity(0.15),
                                radius: 6,
                                y: 3
                            )

                        }
                        .frame(minHeight: 180)

                        .overlay(alignment: .topTrailing) {

                            if showCopied {

                                Label(
                                    "Kopiert!",
                                    systemImage: "checkmark.circle.fill"
                                )
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.orange)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                                .padding()
                                .transition(.scale.combined(with: .opacity))

                            }
                        }

                    }
                    .padding(.horizontal)

                    Spacer(minLength: 30)

                }
            }

            .navigationTitle("JSON Escape Studio")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItemGroup(placement: .keyboard) {

                    Spacer()

                    Button("Fertig") {
                        hideKeyboard()
                    }
                    .font(.headline)
                }
            }

            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    // MARK: UI Backgrounds

    private var editorBackground: some View {

        RoundedRectangle(cornerRadius: 10)
            .fill(.gray.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isEditorFocused
                            ? .blue
                            : .blue.opacity(0.3),
                        lineWidth: isEditorFocused ? 1.8 : 1.2
                    )
            )
    }

    private var outputBackground: some View {

        LinearGradient(

            colors:
                colorScheme == .dark
                ? [.black, Color("#1C1C1E")]
                : [Color("#FFFFFF"), Color("#F2F2F7")],

            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: Actions

    private func copyOutput() {

        UIPasteboard.general.string = outputText

        withAnimation(.spring()) {
            showCopied = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {

            withAnimation {
                showCopied = false
            }
        }
    }

    private func pasteInput() {

        guard let text = UIPasteboard.general.string,
            !text.isEmpty
        else { return }

        inputText = text
    }
}

// MARK: Escape Helpers

func escapeForJSON(_ text: String) -> String {

    text
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\"", with: "\\\"")
        .replacingOccurrences(of: "\n", with: "\\n")
        .replacingOccurrences(of: "\t", with: "\\t")
}

func unescapeFromJSON(_ text: String) -> String {

    text
        .replacingOccurrences(of: "\\n", with: "\n")
        .replacingOccurrences(of: "\\t", with: "\t")
        .replacingOccurrences(of: "\\\"", with: "\"")
        .replacingOccurrences(of: "\\\\", with: "\\")
}

#if canImport(UIKit)
    extension View {

        func hideKeyboard() {

            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
#endif

#Preview {

    JSONEscapeStudioView()
        .preferredColorScheme(.dark)
}
