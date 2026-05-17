//
//  FavoritesView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct FavoritesView: View {

    @Environment(\.horizontalSizeClass)
    private var sizeClass

    @StateObject
    private var favoritesStore =
        FavoritesStore.shared
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
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
