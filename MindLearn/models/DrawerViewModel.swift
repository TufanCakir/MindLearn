//
//  DrawerViewModel.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

internal import Combine
import SwiftUI

@MainActor
final class DrawerViewModel: ObservableObject {

    @Published private(set) var sections: [DrawerSection] = []

    @Published var selectedCategory = Category.all

    @Published private(set) var categories: [String] = []

    enum Category {
        static let all = "Alle"
    }

    var filteredSections: [DrawerSection] {
        guard selectedCategory != Category.all else { return sections }

        return sections.filter {
            normalized($0.category) == normalized(selectedCategory)
        }
    }

    init() {
        loadSections()
    }

    func style(for category: String) -> CategoryStyle {
        CategoryStyle.style(for: category)
    }

    private func loadSections() {
        sections = Self.uniqueSections(
            DrawerSectionLoader.shared.loadAll(DrawerDataFile.allCases)
        )
        categories = buildCategories()
    }

    private func buildCategories() -> [String] {
        let unique = Set(sections.map { normalized($0.category) })

        return [Category.all] + unique.sorted()
    }

    private func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func uniqueSections(_ sections: [DrawerSection])
        -> [DrawerSection]
    {
        var seen = Set<String>()

        return
            sections
            .filter { seen.insert($0.id).inserted }
            .sorted {
                $0.title.localizedStandardCompare($1.title) == .orderedAscending
            }
    }
}

extension DrawerViewModel {
    func colorForCategory(_ category: String) -> Color {
        guard category != Category.all else {
            return .accentColor
        }

        return style(for: category).color
    }
}
