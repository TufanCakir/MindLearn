//
//  InfoView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct InfoView: View {

    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var content: InfoContent {
        Bundle.main.loadKhioneInfo(language: language)
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                header

                ForEach(content.sections) { section in
                    infoCard(section)
                }

                Spacer(minLength: 24)
            }
            .padding(.vertical)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle(content.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
// MARK: - Header
//

extension InfoView {

    private var header: some View {

        VStack(spacing: 14) {

            Image(systemName: "book")
                .font(.system(size: 42))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.primary)
                .padding(18)
                .background(.ultraThinMaterial)
                .clipShape(Circle())

            Text(content.subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

//
// MARK: - Info Card
//

extension InfoView {

    private func infoCard(
        _ section: InfoSection
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Text(section.title)
                .font(.headline)

            Text(section.text)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)

        .background(

            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(Color(.secondarySystemGroupedBackground))
        )

        .overlay(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .stroke(
                Color(.separator),
                lineWidth: 1
            )
        )

        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        InfoView()
    }
}
