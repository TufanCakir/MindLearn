//
//  SyntaxHighlighter.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

actor SyntaxHighlighter {

    static let shared = SyntaxHighlighter()

    private init() {}

    // MARK: Regex Cache

    private enum Regex {

        static let swift =
            try! NSRegularExpression(

                pattern:
                    "\\b(import|struct|class|actor|enum|protocol|extension|func|init|let|var|if|else|guard|return|async|await|private|public|internal|static|override)\\b"
            )

        static let jsonKey =
            try! NSRegularExpression(
                pattern: "\"[^\"]+\"(?=\\s*:)"
            )

        static let htmlTag =
            try! NSRegularExpression(
                pattern: "</?[a-zA-Z0-9\\-]+[^>]*>"
            )

        static let htmlAttribute =
            try! NSRegularExpression(

                pattern:
                    "\\b(href|src|class|id|style|type|name|rel|alt|width|height)\\b"
            )

        static let css =
            try! NSRegularExpression(

                pattern:
                    "\\b(display|flex|grid|color|background|padding|margin|position|width|height|gap)\\b"
            )

        static let js =
            try! NSRegularExpression(

                pattern:
                    "\\b(function|const|let|var|return|document|console|log|useState|useEffect)\\b"
            )

        static let string =
            try! NSRegularExpression(
                pattern: "\"([^\"\\\\]|\\\\.)*\""
            )

        static let comment =
            try! NSRegularExpression(

                pattern: "(//.*?$)|(/\\*.*?\\*/)|<!--.*?-->",

                options: [
                    .anchorsMatchLines,
                    .dotMatchesLineSeparators,
                ]
            )
    }

    // MARK: Highlight

    func highlight(
        _ code: String
    ) async -> AttributedString {

        var attr = AttributedString(code)

        guard !code.isEmpty else {

            return attr
        }

        // PRIORITY ORDER ⭐⭐⭐⭐⭐

        apply(Regex.comment, .gray, &attr, code)

        apply(Regex.string, .orange, &attr, code)

        apply(Regex.jsonKey, .mint, &attr, code)

        apply(Regex.swift, .blue, &attr, code)

        apply(Regex.htmlTag, .pink, &attr, code)

        apply(Regex.htmlAttribute, .cyan, &attr, code)

        apply(Regex.css, .green, &attr, code)

        apply(Regex.js, .yellow, &attr, code)

        return attr
    }

    // MARK: Apply Engine ⭐ FAST

    private func apply(

        _ regex: NSRegularExpression,

        _ color: Color,

        _ attr: inout AttributedString,

        _ code: String

    ) {

        let nsRange = NSRange(

            code.startIndex..<code.endIndex,

            in: code
        )

        regex.enumerateMatches(

            in: code,

            range: nsRange

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
