//
//  JSONTools.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

import Foundation

struct JSONValidationResult {
    let isValid: Bool
    let message: String
    let hint: String?
    let normalizedOutput: String
}

enum JSONTools {

    static func validate(_ input: String) -> JSONValidationResult {

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return .init(
                isValid: false,
                message: "Noch kein JSON eingefügt.",
                hint: "Füge JSON ein oder tippe es in das Feld.",
                normalizedOutput: ""
            )
        }

        let fixed = autoFix(trimmed)

        // Versuch 1: Original
        if let pretty = prettyPrintOrNil(trimmed) {
            return .init(
                isValid: true,
                message: "Alles ok.",
                hint: nil,
                normalizedOutput: pretty
            )
        }

        // Versuch 2: AutoFix Ergebnis
        if fixed != trimmed, let pretty = prettyPrintOrNil(fixed) {
            return .init(
                isValid: false,
                message: "JSON war ungültig – Auto-Fix könnte helfen.",
                hint:
                    "Tippe auf „Auto-Fix“ (Smart Quotes, Trailing Commas, BOM…).",
                normalizedOutput: pretty
            )
        }

        // Fehlertext (Foundation ist leider nicht super detailliert)
        let msg = foundationErrorMessage(for: trimmed)

        return .init(
            isValid: false,
            message: msg,
            hint:
                "Typische Fehler: fehlende Kommas, falsche Anführungszeichen, trailing comma.",
            normalizedOutput: ""
        )
    }

    static func prettyPrint(_ input: String) -> String {
        prettyPrintOrNil(autoFix(input)) ?? input
    }

    static func minify(_ input: String) -> String {
        minifyOrNil(autoFix(input)) ?? input
    }

    // MARK: - AutoFix

    static func autoFix(_ input: String) -> String {

        var s = input

        // BOM entfernen
        s = s.replacingOccurrences(of: "\u{FEFF}", with: "")

        // Smart quotes → normale quotes
        s =
            s
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .replacingOccurrences(of: "„", with: "\"")
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "‘", with: "'")

        // Trailing commas entfernen:  ,}  oder  ,]
        // (simple + praktisch für Copy/Paste JSON)
        s = removeTrailingCommas(s)

        // Manche Leute kopieren JSON in ``` ``` oder mit Kommentarzeilen
        s = stripMarkdownCodeFences(s)

        return
            s
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Internal

    private static func prettyPrintOrNil(_ input: String) -> String? {
        guard let data = input.data(using: .utf8) else { return nil }
        do {
            let obj = try JSONSerialization.jsonObject(
                with: data,
                options: [.fragmentsAllowed]
            )
            let out = try JSONSerialization.data(
                withJSONObject: obj,
                options: [.prettyPrinted, .sortedKeys]
            )
            return String(data: out, encoding: .utf8)
        } catch {
            return nil
        }
    }

    private static func minifyOrNil(_ input: String) -> String? {
        guard let data = input.data(using: .utf8) else { return nil }
        do {
            let obj = try JSONSerialization.jsonObject(
                with: data,
                options: [.fragmentsAllowed]
            )
            let out = try JSONSerialization.data(
                withJSONObject: obj,
                options: []
            )
            return String(data: out, encoding: .utf8)
        } catch {
            return nil
        }
    }

    private static func foundationErrorMessage(for input: String) -> String {
        guard let data = input.data(using: .utf8) else {
            return "Ungültige UTF-8 Daten."
        }
        do {
            _ = try JSONSerialization.jsonObject(
                with: data,
                options: [.fragmentsAllowed]
            )
            return "Unbekannter Fehler."
        } catch {
            return error.localizedDescription
        }
    }

    private static func stripMarkdownCodeFences(_ s: String) -> String {
        var out = s.trimmingCharacters(in: .whitespacesAndNewlines)
        if out.hasPrefix("```") {
            // Entferne erste Zeile ``` oder ```json
            if let firstNewline = out.firstIndex(of: "\n") {
                out = String(out[out.index(after: firstNewline)...])
            }
            // Entferne letztes ```
            if let range = out.range(of: "```", options: .backwards) {
                out.removeSubrange(range)
            }
        }
        return out.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func removeTrailingCommas(_ s: String) -> String {
        // Simple RegEx: ",\s*}" und ",\s*]"
        // Foundation on iOS: NSRegularExpression
        let patterns = [#",\s*}"#, #",\s*]"#]
        var out = s
        for p in patterns {
            if let re = try? NSRegularExpression(pattern: p, options: []) {
                let range = NSRange(out.startIndex..<out.endIndex, in: out)
                out = re.stringByReplacingMatches(
                    in: out,
                    options: [],
                    range: range,
                    withTemplate: p.contains("}") ? "}" : "]"
                )
            }
        }
        return out
    }
}
