//
//  DrawerViewModel.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class DrawerViewModel {

    private(set) var sections: [DrawerSection] = []

    var selectedCategory: ContentCategoryFilter = .all

    private(set) var categories: [ContentCategoryFilter] = []

    private(set) var loadingError: Error?

    private let sectionProvider: any DrawerSectionProviding

    var filteredSections: [DrawerSection] {
        guard let category = selectedCategory.category else { return sections }

        return sections.filter {
            $0.category == category
        }
    }

    convenience init() {
        self.init(sectionProvider: DrawerSectionLoader.shared)
    }

    init(sectionProvider: any DrawerSectionProviding) {
        self.sectionProvider = sectionProvider
        loadSections()
    }

    func style(for filter: ContentCategoryFilter) -> CategoryStyle {
        guard let category = filter.category else {
            return CategoryStyle(icon: "square.grid.2x2", color: .accentColor)
        }
        return CategoryStyle.style(for: category)
    }

    private func loadSections() {
        do {
            sections = Self.uniqueSections(try sectionProvider.loadAllSections())
            loadingError = nil
        } catch {
            sections = []
            loadingError = error
        }
        categories = buildCategories()
    }

    private func buildCategories() -> [ContentCategoryFilter] {
        let unique = Set(sections.map(\.category))

        return [.all] + unique.sorted { $0.rawValue < $1.rawValue }
            .map(ContentCategoryFilter.category)
    }

    private static func uniqueSections(_ sections: [DrawerSection])
        -> [DrawerSection]
    {
        var seen = Set<String>()

        return
            sections
            .filter { seen.insert($0.id).inserted }
            .sorted {
                $0.title.de.localizedStandardCompare($1.title.de)
                    == .orderedAscending
            }
    }
}

extension DrawerViewModel {
    func colorForCategory(_ filter: ContentCategoryFilter) -> Color {
        style(for: filter).color
    }
}
