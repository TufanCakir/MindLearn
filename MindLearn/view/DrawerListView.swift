//
//  DrawerListView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct DrawerListView: View {

    @State private var sections: [DrawerSection] = []

    var body: some View {

        Group {

            if sections.isEmpty {

                emptyState

            } else {

                content
            }
        }

        .task {

            await loadSections()
        }
    }
}

// MARK: - Content

extension DrawerListView {

    private var content: some View {

        ScrollView {

            LazyVStack(spacing: 14) {

                ForEach(sections) { section in

                    NavigationLink {

                        DrawerDetailView(
                            section: section
                        )

                    } label: {

                        drawerCard(section)
                    }

                    .buttonStyle(.plain)
                }
            }
            .padding()
        }

        .background(
            Color(.systemGroupedBackground)
        )
    }
}

// MARK: - Card

extension DrawerListView {

    private func drawerCard(
        _ section: DrawerSection
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(section.title)
                .font(.headline.weight(.semibold))

            Text(section.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }

        .padding(18)

        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )

        .background {

            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )

            .fill(.thinMaterial)
        }

        .overlay {

            RoundedRectangle(
                cornerRadius: 18
            )

            .strokeBorder(
                .quaternary
            )
        }

        .shadow(
            radius: 6,
            y: 3
        )
    }
}

// MARK: - Empty

extension DrawerListView {

    private var emptyState: some View {

        ContentUnavailableView(

            "Keine Dokumentation",

            systemImage: "book.closed",

            description: Text(
                "Keine Inhalte gefunden."
            )
        )

        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

// MARK: - Load

extension DrawerListView {

    private func loadSections() async {

        let loaded =
            DrawerSectionLoader
            .shared
            .loadAll(
                DrawerDataFile.allCases
            )

        sections =
            loaded
            .uniqued(by: \.id)
            .sorted {

                $0.title.localizedStandardCompare(
                    $1.title
                ) == .orderedAscending
            }
    }
}

// MARK: - Helpers

extension Array {

    func uniqued<T: Hashable>(
        by keyPath: KeyPath<Element, T>
    ) -> [Element] {

        var seen = Set<T>()

        return filter {

            seen.insert(
                $0[keyPath: keyPath]
            ).inserted
        }
    }
}

#Preview {
    DrawerListView()
}
