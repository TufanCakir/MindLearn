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

    private let keywordRegex = try! NSRegularExpression(

        pattern:

            "\\b(import|struct|class|func|let|var|if|else|return|async|await|View|NavigationStack|Button|Text|VStack|HStack|ZStack)\\b"

    )

    private let stringRegex =
        try! NSRegularExpression(
            pattern: "\".*?\""
        )

    private let commentRegex =
        try! NSRegularExpression(
            pattern: "//.*"
        )

    func highlight(
        _ code: String
    ) async -> AttributedString {

        var attr = AttributedString(code)

        apply(
            keywordRegex,
            color: .blue,
            to: &attr,
            code: code
        )

        apply(
            stringRegex,
            color: .orange,
            to: &attr,
            code: code
        )

        apply(
            commentRegex,
            color: .gray,
            to: &attr,
            code: code
        )

        return attr
    }

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
