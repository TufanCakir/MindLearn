import Foundation
import SwiftData

@Model
final class Favorite {
    @Attribute(.unique) var topicID: String
    var createdAt: Date

    init(topicID: String, createdAt: Date = .now) {
        self.topicID = topicID
        self.createdAt = createdAt
    }
}

@MainActor
enum FavoritesRepository {
    static let legacyKey = "favoriteIDs"

    static func toggle(
        topicID: String,
        favorites: [Favorite],
        in context: ModelContext
    ) throws {
        if let favorite = favorites.first(where: { $0.topicID == topicID }) {
            context.delete(favorite)
        } else {
            context.insert(Favorite(topicID: topicID))
        }

        try context.save()
    }

    static func migrateLegacyFavorites(
        from defaults: UserDefaults,
        into context: ModelContext
    ) throws {
        let legacyIDs = Set(
            defaults.string(forKey: legacyKey)?
                .split(separator: ",")
                .map(String.init) ?? []
        )
        guard !legacyIDs.isEmpty else { return }

        let existing = try context.fetch(FetchDescriptor<Favorite>())
        let existingIDs = Set(existing.map(\.topicID))

        for topicID in legacyIDs.subtracting(existingIDs) {
            context.insert(Favorite(topicID: topicID))
        }

        try context.save()
        defaults.removeObject(forKey: legacyKey)
    }
}
