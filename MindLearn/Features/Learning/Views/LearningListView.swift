//
//  LearningListView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

struct LearningListView: View {

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    @State
    private var vm =
        LearningListViewModel()
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    var body: some View {
        @Bindable var vm = vm

        VStack(spacing: 0) {

            stickyHeader

            Divider()

            contentScroll
        }

        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .searchable(
            text: $vm.searchText,
            placement: .toolbar,
            prompt: text.learningList.searchPlaceholder
        )
        .searchToolbarBehavior(.minimize)
        .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
    }
}

extension LearningListView {

    private var stickyHeader: some View {

        VStack(spacing: 14) {

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

    @Query private var progressRecords: [LearningProgress]
    @Query private var favorites: [Favorite]
    @Environment(\.modelContext) private var modelContext

    var body: some View {

        LazyVGrid(

            columns: gridLayout,
            spacing: 30

        ) {

            ForEach(topics) { topic in
                NavigationLink {
                    LearningDetailView(topic: topic)
                } label: {
                    LearningCard(
                        topic: topic,
                        progressStatus: progressStatus(for: topic.id),
                        isFavorite: isFavorite(topic.id),
                        onToggleFavorite: { toggleFavorite(topic.id) }
                    )
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

    private func progressStatus(for topicID: String) -> LearningProgressStatus {
        progressRecords.first { $0.topicID == topicID }?.status ?? .unread
    }

    private func isFavorite(_ topicID: String) -> Bool {
        favorites.contains { $0.topicID == topicID }
    }

    private func toggleFavorite(_ topicID: String) {
        do {
            try FavoritesRepository.toggle(
                topicID: topicID,
                favorites: favorites,
                in: modelContext
            )
        } catch {
            assertionFailure("Could not update favorite: \(error)")
        }
    }
}

extension LearningListView {
    // Horizontal padding used across the view; adapts to size class
    var horizontalPadding: CGFloat {
        sizeClass == .regular ? 24 : 16
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
        _ category: ContentCategoryFilter
    ) -> some View {

        let selected =
            vm.selectedCategory == category

        let style: CategoryStyle
        if let categoryName = category.category {
            style = CategoryStyle.style(for: categoryName)
        } else {
            style = CategoryStyle(
                icon: "square.grid.2x2",
                color: .accentColor
            )
        }

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

                Text(category.title(allTitle: text.learningList.all))

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

            text.learningList.emptyTitle,

            systemImage: "magnifyingglass",

            description: Text(
                text.learningList.emptyDescription
            )
        )

        .frame(
            maxWidth: .infinity,
            minHeight: 260
        )
    }
}

#Preview {
    PreviewRoot {
        LearningListView()
    }
}
