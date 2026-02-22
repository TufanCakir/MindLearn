//
//  LearningListView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct LearningListView: View {

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    @StateObject private var vm =
        LearningListViewModel(
            favorites:
                Set(
                    UserDefaults.standard
                        .string(forKey: "favoriteIDs")?
                        .split(separator: ",")
                        .map(String.init) ?? []
                )
        )

    var body: some View {

        ScrollView {

            LazyVStack(
                spacing: 18,
                pinnedViews: []
            ) {

                filterArea

                if vm.filteredTopics.isEmpty {

                    emptyState

                } else {

                    LearningGrid(
                        topics: vm.filteredTopics,
                        gridLayout: gridLayout
                    )
                }
            }

            .padding(.top,8)
        }

        .navigationTitle("Lernen")

        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LearningGrid: View {

    let topics: [LearningTopic]

    let gridLayout: [GridItem]

    var body: some View {

        LazyVGrid(

            columns: gridLayout,
            spacing: 18

        ) {

            ForEach(topics) { topic in

                NavigationLink {

                    LearningDetailView(
                        topic: topic
                    )

                } label: {

                    LearningCard(
                        topic: topic
                    )
                }

                .buttonStyle(.plain)
            }
        }

        .padding(.horizontal,16)
        .padding(.bottom,20)
    }
}

extension LearningListView {
    // Horizontal padding used across the view; adapts to size class
    var horizontalPadding: CGFloat {
        sizeClass == .regular ? 24 : 16
    }
}

extension LearningListView {

    private var filterArea: some View {

        VStack(spacing: 14) {

            searchBar

            categoryTabs
        }

        .padding(.horizontal,horizontalPadding)

        .padding(.vertical,12)

        .background {

            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )

            .fill(.ultraThinMaterial)
        }

        .padding(.horizontal,horizontalPadding)
    }
}

extension LearningListView {

    private var searchBar: some View {

        HStack(spacing:10) {

            Image(systemName:"magnifyingglass")

            TextField(
                "Suche…",
                text:$vm.searchText
            )

            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

            if !vm.searchText.isEmpty {

                Button {

                    vm.searchText=""

                } label: {

                    Image(systemName:"xmark.circle.fill")
                }
            }
        }

        .padding(12)

        .background {

            RoundedRectangle(
                cornerRadius:14,
                style:.continuous
            )
            .fill(.thinMaterial)
        }
    }
}

extension LearningListView {

    private var categoryTabs: some View {

        ScrollView(.horizontal,showsIndicators:false){

            HStack(spacing:10){

                ForEach(vm.categories,id:\.self){

                    categoryButton($0)
                }
            }
        }
    }
}

extension LearningListView {

    private func categoryButton(
        _ category: String
    ) -> some View {

        let selected =
            vm.selectedCategory == category

        return Button {

            withAnimation(.spring()) {

                vm.selectedCategory = category
            }

        } label: {

            Text(category)

                .font(.caption.bold())

                .padding(.horizontal,14)
                .padding(.vertical,8)

                .background {

                    Capsule()

                        .fill(

                            selected
                            ? Color.accentColor.opacity(0.25)

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
                spacing: 18
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

            systemImage:"magnifyingglass",

            description:Text(
                "Versuche andere Suchbegriffe."
            )
        )

        .frame(
            maxWidth:.infinity,
            minHeight:260
        )
    }
}

#Preview {
    LearningListView()
}

