//
//  DrawerListView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct DrawerListView: View {

    let selectedCategory: String
    @State private var sections: [DrawerSection] = []

    private var filteredSections: [DrawerSection] {

        guard selectedCategory != "Alle" else { return sections }

        return sections.filter {
            $0.category.trimmingCharacters(in: .whitespacesAndNewlines)
            ==
            selectedCategory.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

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

extension DrawerListView {

    private var content: some View {

        ScrollView {

            LazyVStack(spacing: 16) {

                ForEach(filteredSections) { section in

                    NavigationLink {

                        DrawerDetailView(section: section)

                    } label: {

                        drawerCard(section)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
    }
}

//
// MARK: CARD ⭐
//

extension DrawerListView {
    
    private func drawerCard(
        _ section: DrawerSection
    ) -> some View {
        
        // ⭐ Category Mapping
        let style =
        CategoryStyle.style(
            for: section.category
        )
        
        return HStack(spacing: 14) {
            
            //
            // ICON BADGE ⭐
            //
            
            Image(systemName: style.icon)
            
                .font(.headline)
            
                .foregroundStyle(style.color)
            
                .frame(width: 40, height: 40)
            
                .background(
                    
                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                    
                    .fill(
                        style.color.opacity(0.15)
                    )
                )
            
            //
            // TEXT
            //
            
            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                
                Text(section.title)
                
                    .font(.headline)
                
                    .lineLimit(1)
                
                Text(section.description)
                
                    .font(.subheadline)
                
                    .foregroundStyle(.secondary)
                
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
            
                .font(.caption.weight(.semibold))
            
                .foregroundStyle(.tertiary)
        }
        
        .padding(16)
        
        .background(
            
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            
            .fill(.ultraThinMaterial)
        )
        
        .overlay(
            
            RoundedRectangle(
                cornerRadius: 20
            )
            
            .stroke(
                Color(.separator),
                lineWidth: 1
            )
        )
        
        .shadow(
            color: .black.opacity(0.08),
            radius: 8,
            y: 4
        )
    }
}

//
// MARK: EMPTY ⭐
//

extension DrawerListView {

    private var emptyState: some View {

        ContentUnavailableView(

            "Keine Dokumentation",

            systemImage: "book.closed",

            description:

                Text(
                    "Keine Inhalte gefunden."
                )
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

//
// MARK: LOAD ⭐
//

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

//
// MARK: HELPERS
//

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

