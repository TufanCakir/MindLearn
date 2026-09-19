import Foundation

enum ContentCategoryFilter: Hashable {
    case all
    case category(ContentCategory)

    var category: ContentCategory? {
        guard case .category(let category) = self else { return nil }
        return category
    }

    func title(allTitle: String) -> String {
        category?.rawValue ?? allTitle
    }
}
