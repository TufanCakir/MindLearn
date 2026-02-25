//
//  JSONActionHeader.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

import SwiftUI

struct JSONActionHeader: View {

    // optional: wenn du einen Picker brauchst (Escape Studio)
    var modeTitle: String? = nil
    var modeSelection: Binding<Bool>? = nil
    var modeFalseTitle: String = ""
    var modeTrueTitle: String = ""

    // actions
    var onPaste: () -> Void
    var onClear: () -> Void

    // optional actions
    var onSwap: (() -> Void)? = nil
    var onAutoFix: (() -> Void)? = nil
    var onPrettyPrint: (() -> Void)? = nil
    var onMinify: (() -> Void)? = nil

    // primary
    var primaryTitle: String
    var primarySystemImage: String
    var primaryEnabled: Bool = true
    var onPrimary: () -> Void

    // secondary (z.B. Share)
    var secondaryTitle: String? = nil
    var secondarySystemImage: String? = nil
    var secondaryEnabled: Bool = true
    var onSecondary: (() -> Void)? = nil

    var body: some View {

        VStack(spacing: 12) {

            if let modeSelection, let modeTitle {
                Picker(modeTitle, selection: modeSelection) {
                    Text(modeFalseTitle).tag(false)
                    Text(modeTrueTitle).tag(true)
                }
                .pickerStyle(.segmented)
            }

            // Row 1 — Utility Actions

            VStack(spacing: 10) {

                // LEFT MAIN ACTIONS
                HStack(spacing: 10) {

                    Button(action: onPaste) {
                        Label("Einfügen", systemImage: "doc.on.clipboard")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(role: .destructive, action: onClear) {
                        Label("Leeren", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                // RIGHT TOOLS (compact icons)
                HStack(spacing: 10) {

                    Spacer()

                    if let onSwap {

                        Button(action: onSwap) {

                            Image(systemName: "arrow.left.arrow.right")
                                .frame(width: 44, height: 44)

                        }
                        .buttonStyle(.bordered)
                    }

                    if let onAutoFix {

                        Button(action: onAutoFix) {

                            Image(systemName: "wand.and.stars")
                                .frame(width: 44, height: 44)

                        }
                        .buttonStyle(.bordered)
                    }

                    if onPrettyPrint != nil || onMinify != nil {

                        Menu {

                            if let onPrettyPrint {

                                Button(action: onPrettyPrint) {

                                    Label(
                                        "Pretty Print",
                                        systemImage: "text.alignleft"
                                    )
                                }
                            }

                            if let onMinify {

                                Button(action: onMinify) {

                                    Label(
                                        "Minify",
                                        systemImage:
                                            "arrow.down.right.and.arrow.up.left"
                                    )
                                }
                            }

                        } label: {

                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                                .frame(width: 44, height: 44)

                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .font(.subheadline.weight(.semibold))

            // Row 2 (primary + optional secondary)
            HStack(spacing: 10) {

                Button(action: onPrimary) {
                    Label(primaryTitle, systemImage: primarySystemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!primaryEnabled)

                if let secondaryTitle,
                    let secondarySystemImage,
                    let onSecondary
                {
                    Button(action: onSecondary) {
                        Label(secondaryTitle, systemImage: secondarySystemImage)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!secondaryEnabled)
                }
            }
            .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
    }
}
