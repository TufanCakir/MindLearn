//
//  FavoritesView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

import SwiftUI

struct FavoritesView: View {

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    @StateObject
    private var favoritesStore =
        FavoritesStore.shared

    var body: some View {

        ScrollView {

            if favoriteTopics.isEmpty {

                emptyState

            } else {

                LearningGrid(

                    topics: favoriteTopics,

                    gridLayout: gridLayout
                )
            }
        }

        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )

        .navigationTitle("Favoriten")
    }
}

extension FavoritesView {

    private var favoriteTopics: [LearningTopic] {

        LearningTopicLoader
            .shared
            .loadAllTopics()

            .filter {

                favoritesStore
                    .favorites
                    .contains($0.id)
            }
    }
}

extension FavoritesView {

    fileprivate var gridLayout: [GridItem] {

        sizeClass == .regular

            ?

            [

                GridItem(

                    .adaptive(

                        minimum: 320,
                        maximum: 420
                    ),

                    spacing: 20
                )
            ]

            :

            [

                GridItem(.flexible())
            ]
    }
}

extension FavoritesView {

    private var emptyState: some View {

        ContentUnavailableView(

            "Keine Favoriten",

            systemImage: "star",

            description: Text(
                "Markiere Inhalte als Favorit."
            )
        )
        .frame(
            maxWidth: .infinity,
            minHeight: 260
        )
    }
}
