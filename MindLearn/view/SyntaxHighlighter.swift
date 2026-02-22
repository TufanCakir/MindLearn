//
//  SyntaxHighlighter.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

actor SyntaxHighlighter {

    static let shared = SyntaxHighlighter()

    private init() {}

    // MARK: Swift Keywords

    private let swiftKeywordRegex =
        try! NSRegularExpression(

            pattern:

                "\\b(import|struct|class|func|let|var|if|else|return|async|await|View|NavigationStack|Button|Text|VStack|HStack|ZStack)\\b"

        )

    // MARK: HTML TAGS

    private let htmlTagRegex =
        try! NSRegularExpression(
            pattern: "</?[a-zA-Z0-9\\-]+[^>]*>"
        )

    // MARK: Attributes (href= src= etc)

    private let htmlAttributeRegex =
        try! NSRegularExpression(
            pattern:
                "\\b(href|src|class|id|style|type|name|content|rel|alt|width|height)\\b"
        )

    private let cssRegex =
        try! NSRegularExpression(
            pattern:
                "\\b(display|flex|grid|color|background|padding|margin|position|width|height|gap|justify-content|align-items)\\b"
        )

    private let jsRegex =
        try! NSRegularExpression(
            pattern:
                "\\b(function|const|let|var|return|document|console|log|onclick|alert)\\b"
        )

    private let jsonKeyRegex =
        try! NSRegularExpression(
            pattern:
                "\"[^\"]+\"(?=\\s*:)"
        )

    // MARK: Strings

    private let stringRegex =
        try! NSRegularExpression(
            pattern: "\".*?\""
        )

    // MARK: Comments Swift + HTML

    private let commentRegex =
        try! NSRegularExpression(
            pattern: "(//.*)|<!--.*?-->",
            options: [.dotMatchesLineSeparators]
        )

    // MARK: Highlight

    func highlight(
        _ code: String
    ) async -> AttributedString {

        var attr = AttributedString(code)

        // Swift

        apply(
            swiftKeywordRegex,
            color: .blue,
            to: &attr,
            code: code
        )

        // HTML Tags

        apply(
            htmlTagRegex,
            color: .pink,
            to: &attr,
            code: code
        )

        // HTML Attributes

        apply(
            htmlAttributeRegex,
            color: .cyan,
            to: &attr,
            code: code
        )

        // CSS

        apply(
            cssRegex,
            color: .green,
            to: &attr,
            code: code
        )

        // JavaScript

        apply(
            jsRegex,
            color: .yellow,
            to: &attr,
            code: code
        )

        // Strings

        apply(
            stringRegex,
            color: .orange,
            to: &attr,
            code: code
        )

        // Comments

        apply(
            commentRegex,
            color: .gray,
            to: &attr,
            code: code
        )

        return attr
    }

    // MARK: Apply Regex

    private func apply(

        _ regex: NSRegularExpression,
        color: Color,
        to attr: inout AttributedString,
        code: String

    ) {

        let range =
            NSRange(
                code.startIndex..<code.endIndex,
                in: code
            )

        regex.enumerateMatches(
            in: code,
            range: range
        ) { match, _, _ in

            guard
                let match,
                let r = Range(
                    match.range,
                    in: code
                ),

                let lower =
                    AttributedString.Index(
                        r.lowerBound,
                        within: attr
                    ),

                let upper =
                    AttributedString.Index(
                        r.upperBound,
                        within: attr
                    )

            else { return }

            attr[lower..<upper]
                .foregroundColor = color
        }
    }
}
