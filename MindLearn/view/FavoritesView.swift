//
//  FavoritesView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    @Query private var favorites: [Favorite]
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

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

        .navigationTitle(text.favorites.title)
        .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
    }
}

extension FavoritesView {

    private var favoriteTopics: [LearningTopic] {

        (try? LearningTopicLoader
            .shared
            .loadAllTopics()) ?? []

            .filter {

                favoriteIDs.contains($0.id)
            }
    }

    private var favoriteIDs: Set<String> {
        Set(favorites.map(\.topicID))
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

            text.favorites.emptyTitle,

            systemImage: "star",

            description: Text(
                text.favorites.emptyDescription
            )
        )
        .frame(
            maxWidth: .infinity,
            minHeight: 260
        )
    }
}
