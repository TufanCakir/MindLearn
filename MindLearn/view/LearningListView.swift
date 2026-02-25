//
//  LearningListView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct LearningListView: View {

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    @StateObject
    private var vm =
        LearningListViewModel()

    var body: some View {

        VStack(spacing: 0) {

            stickyHeader

            Divider()

            contentScroll
        }

        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }
}

extension LearningListView {

    private var stickyHeader: some View {

        VStack(spacing: 14) {

            searchBar

            categoryTabs
        }

        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 14)

        .background(.ultraThinMaterial)

        .shadow(
            color: .black.opacity(0.08),
            radius: 8,
            y: 4
        )
    }
}

extension LearningListView {

    private var contentScroll: some View {

        ScrollView {

            VStack {

                if vm.filteredTopics.isEmpty {

                    emptyState

                } else {

                    LearningGrid(
                        topics: vm.filteredTopics,
                        gridLayout: gridLayout
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
        }
        .scrollIndicators(.visible)
    }
}

struct LearningGrid: View {

    let topics: [LearningTopic]

    let gridLayout: [GridItem]

    var body: some View {

        LazyVGrid(

            columns: gridLayout,
            spacing: 30

        ) {

            ForEach(topics) { topic in
                NavigationLink {
                    LearningDetailView(topic: topic)
                } label: {
                    LearningCard(topic: topic)
                }
                .buttonStyle(PressableCardStyle())
            }
        }

        .frame(
            maxWidth: 900
        )

        .frame(
            maxWidth: .infinity
        )

        .padding(.horizontal, 16)
        .padding(.bottom, 28)
    }
}

extension LearningListView {
    // Horizontal padding used across the view; adapts to size class
    var horizontalPadding: CGFloat {
        sizeClass == .regular ? 24 : 16
    }
}

extension LearningListView {

    private var searchBar: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Suche…",
                text: $vm.searchText
            )
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

            if !vm.searchText.isEmpty {

                Button {

                    vm.searchText = ""

                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }

        .padding(12)

        .background {

            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
            .fill(.thinMaterial)
        }
    }
}

extension LearningListView {

    private var categoryTabs: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 10) {

                ForEach(vm.categories, id: \.self) {

                    categoryButton($0)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

extension LearningListView {

    private func categoryButton(
        _ category: String
    ) -> some View {

        let selected =
            vm.selectedCategory == category

        let style =
            CategoryStyle.style(
                for: category
            )

        let color = style.color

        return Button {

            withAnimation(.spring()) {

                vm.selectedCategory = category
            }

        } label: {

            HStack(spacing: 8) {

                Image(systemName: style.icon)

                    .font(.caption.bold())

                    .foregroundStyle(

                        selected
                            ? color
                            : .primary
                    )

                Text(category)

                    .font(.caption.bold())

                    .foregroundStyle(

                        selected
                            ? color
                            : .primary
                    )
            }

            .padding(.horizontal, 14)
            .padding(.vertical, 8)

            .background {

                Capsule()

                    .fill(

                        selected

                            ? color.opacity(0.25)

                            : Color.secondary.opacity(0.12)
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

extension LearningListView {
    fileprivate var gridLayout: [GridItem] {

        sizeClass == .regular
            ? [
                GridItem(
                    .adaptive(
                        minimum: 320,
                        maximum: 420
                    ),
                    spacing: 20
                )
            ]

            : [
                GridItem(.flexible())
            ]
    }
}

extension LearningListView {

    private var emptyState: some View {

        ContentUnavailableView(

            "Keine Ergebnisse",

            systemImage: "magnifyingglass",

            description: Text(
                "Versuche andere Suchbegriffe."
            )
        )

        .frame(
            maxWidth: .infinity,
            minHeight: 260
        )
    }
}

#Preview {
    LearningListView()
}
