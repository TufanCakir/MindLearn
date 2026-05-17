//
//  CodeChallengeView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct CodeChallengeView: View {
    let task: CodingTask

    @State private var code: String
    @State private var result: CodingTaskResult?
    @State private var showHint = false
    @State private var showSolution = false
    @State private var shareItems: [Any] = []
    @State private var showShareSheet = false

    @FocusState private var isFocused: Bool

    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    init(task: CodingTask) {
        self.task = task
        self._code = State(initialValue: task.starterCode)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                taskHeader
                editor
                actionRow
                resultView
                hintView
                solutionView
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(task.title(language: language))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            keyboardToolbar
            shareToolbar
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: shareItems)
        }
    }
}

extension CodeChallengeView {
    private var taskHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.explanation(language: language))
                .font(.body)
                .foregroundStyle(.secondary)

            Text(task.instruction(language: language))
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .challengeCard()
    }

    private var editor: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(text.challenge.yourCode, systemImage: "keyboard")
                .font(.headline)

            TextEditor(text: $code)
                .focused($isFocused)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 260)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(
                            isFocused ? .blue : Color(.separator),
                            lineWidth: 1
                        )
                )
        }
    }

    private var actionRow: some View {
        VStack(spacing: 10) {
            Button {
                result = task.evaluate(code)
            } label: {
                Label(text.challenge.check, systemImage: "checkmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            HStack(spacing: 10) {
                Button {
                    shareProgress()
                } label: {
                    Label(text.common.share, systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    showHint.toggle()
                } label: {
                    Label(text.challenge.showHint, systemImage: "lightbulb")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    showSolution.toggle()
                } label: {
                    Label(text.challenge.showSolution, systemImage: "doc.text")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    @ViewBuilder
    private var resultView: some View {
        if let result {
            VStack(alignment: .leading, spacing: 8) {
                Label(
                    result.isCorrect
                        ? text.challenge.correctTitle
                        : text.challenge.incorrectTitle,
                    systemImage: result.isCorrect
                        ? "checkmark.seal.fill" : "xmark.octagon.fill"
                )
                .font(.headline)
                .foregroundStyle(result.isCorrect ? .green : .red)

                if !result.missingKeywords.isEmpty {
                    Text(
                        "\(text.challenge.missingKeywords): \(result.missingKeywords.joined(separator: ", "))"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
            .challengeCard()
        }
    }

    @ViewBuilder
    private var hintView: some View {
        if showHint {
            Text(task.hint(language: language))
                .font(.subheadline)
                .challengeCard()
        }
    }

    @ViewBuilder
    private var solutionView: some View {
        if showSolution {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(text.challenge.solution)
                        .font(.headline)

                    Spacer()

                    Button {
                        shareSolution()
                    } label: {
                        Label(
                            text.challenge.shareSolution,
                            systemImage: "square.and.arrow.up"
                        )
                    }
                    .buttonStyle(.bordered)
                }

                CodeView(code: task.solution)
            }
        }
    }

    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(text.common.done) {
                isFocused = false
            }
        }
    }

    private var shareToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                shareProgress()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel(text.challenge.shareProgress)
        }
    }

    private func shareProgress() {
        if result == nil {
            result = task.evaluate(code)
        }

        shareItems = [shareText(includeSolution: false)]
        showShareSheet = true
    }

    private func shareSolution() {
        shareItems = [shareText(includeSolution: true)]
        showShareSheet = true
    }

    private func shareText(includeSolution: Bool) -> String {
        let evaluated = result ?? task.evaluate(code)
        let status =
            evaluated.isCorrect
            ? text.challenge.correctTitle
            : text.challenge.incorrectTitle

        var output = """
            MindLearn
            \(text.challenge.taskLabel): \(task.title(language: language))
            \(text.challenge.languageLabel): \(task.language)
            \(text.challenge.statusLabel): \(status)
            """

        if !evaluated.missingKeywords.isEmpty {
            output +=
                "\n\(text.challenge.missingKeywords): \(evaluated.missingKeywords.joined(separator: ", "))"
        }

        output += """


            \(text.challenge.myCodeLabel):
            \(code)
            """

        if includeSolution {
            output += """


                \(text.challenge.solution):
                \(task.solution)
                """
        }

        return output
    }
}

extension View {
    fileprivate func challengeCard() -> some View {
        padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.separator).opacity(0.45), lineWidth: 1)
            )
    }
}
