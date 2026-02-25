//
//  SideDrawerView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct SideDrawerView: View {

    @Binding var showDrawer: Bool

    @State private var selectedCategory: String = "Alle"
    @State private var categories: [DrawerCategoryItem] = []

    var body: some View {

        VStack(spacing: 0) {

            header

            Divider()

            categoryTabs  // ⭐ NEU

            Divider()

            DrawerListView(selectedCategory: selectedCategory)  // ⭐ gefiltert

            closeButton
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color(.systemGroupedBackground))
        .task { await loadCategories() }  // ⭐ NEU
    }
}

// MARK: - Category Model

struct DrawerCategoryItem: Identifiable {

    let id = UUID()
    let name: String

    var style: CategoryStyle {

        CategoryStyle.style(for: name)
    }
}

// MARK: - Category Tabs

extension SideDrawerView {

    private var categoryTabs: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 10) {

                ForEach(categories) { item in

                    categoryButton(item)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
    }

    private func categoryButton(
        _ item: DrawerCategoryItem
    ) -> some View {

        let selected = selectedCategory == item.name

        let style = item.style
        let color = style.color

        return Button {

            withAnimation(.spring()) {

                selectedCategory = item.name
            }

        } label: {

            HStack(spacing: 8) {

                Image(systemName: style.icon)
                    .font(.caption.bold())
                    .foregroundStyle(
                        selected ? color : .primary
                    )

                Text(item.name)
                    .font(.caption.bold())
                    .foregroundStyle(
                        selected ? color : .primary
                    )
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {

                Capsule()
                    .fill(

                        selected
                            ? color.opacity(0.22)
                            : Color.secondary.opacity(0.12)
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Load Categories

extension SideDrawerView {

    private func loadCategories() async {

        let sections =
            DrawerSectionLoader.shared
            .loadAll(DrawerDataFile.allCases)

        let uniqueCategories = Set(

            sections.map {

                $0.category
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
            }
        )

        var result: [DrawerCategoryItem] = [

            DrawerCategoryItem(
                name: "Alle"
            )
        ]

        result +=
            uniqueCategories

            .map {

                DrawerCategoryItem(
                    name: $0
                )
            }

            .sorted {

                $0.name.localizedStandardCompare(
                    $1.name
                ) == .orderedAscending
            }

        categories = result
    }
}

extension SideDrawerView {

    private var header: some View {

        HStack {

            Label(
                "Dokumentation",
                systemImage: "book.fill"
            )
            .font(.title3.bold())

            Spacer()
        }
        .padding()
    }
}

extension SideDrawerView {

    private var closeButton: some View {

        Button {

            closeDrawer()

        } label: {

            Text("Schließen")
                .frame(maxWidth: .infinity)
        }

        .buttonStyle(.borderedProminent)

        .padding()
    }
}

extension SideDrawerView {

    private func closeDrawer() {

        withAnimation(
            .spring(
                response: 0.45,
                dampingFraction: 0.8
            )
        ) {

            showDrawer = false
        }
    }
}

#Preview {

    SideDrawerView(
        showDrawer: .constant(false)
    )
}
