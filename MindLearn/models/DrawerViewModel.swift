//
//  DrawerViewModel.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

internal import Combine
import SwiftUI

@MainActor
final class DrawerViewModel: ObservableObject {

    @Published private(set)
        var sections: [DrawerSection] = []

    @Published
    var selectedCategory: String = "Alle"

    @Published private(set)
        var categories: [String] = []

    enum Category {

        static let all = "Alle"
    }

    init() {

        loadSections()
    }

    private func loadSections() {

        sections =
            DrawerSectionLoader.shared.loadAll(
                DrawerDataFile.allCases
            )

        categories = buildCategories()
    }

    private func buildCategories() -> [String] {

        let unique = Set(

            sections.map {

                $0.category
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
            }
        )

        return [Category.all] + unique.sorted()
    }
}

extension DrawerViewModel {

    func colorForCategory(
        _ category: String
    ) -> Color {

        guard category != Category.all else {

            return .accentColor
        }

        return
            CategoryStyle
            .style(for: category)
            .color
    }
}
