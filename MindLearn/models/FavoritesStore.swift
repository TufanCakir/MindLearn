//
//  FavoritesStore.swift.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

internal import Combine
import SwiftUI

@MainActor
final class FavoritesStore: ObservableObject {

    static let shared = FavoritesStore()

    @Published var favorites: Set<String> = []

    private let key = "favoriteIDs"

    private init() {

        load()
    }

    private func load() {

        let string =
            UserDefaults.standard.string(
                forKey: key
            ) ?? ""

        favorites =
            Set(
                string
                    .split(separator: ",")
                    .map(String.init)
            )
    }

    func toggle(id: String) {

        if favorites.contains(id) {

            favorites.remove(id)

        } else {

            favorites.insert(id)
        }

        save()
    }

    private func save() {

        UserDefaults.standard.set(

            favorites.sorted().joined(
                separator: ","
            ),

            forKey: key
        )
    }
}
