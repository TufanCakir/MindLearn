//
//  AppLocalization.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

enum LocalizationLoadingError: LocalizedError {
    case missingResource
    case unreadableResource(Error)
    case invalidResource(Error)
    case missingFallbackLanguage

    var errorDescription: String? {
        switch self {
        case .missingResource:
            "The localization file is missing."
        case .unreadableResource:
            "The localization file could not be read."
        case .invalidResource:
            "The localization file contains invalid data."
        case .missingFallbackLanguage:
            "The English fallback localization is missing."
        }
    }
}

struct AppLocalization: Decodable {
    let tabs: TabText
    let settings: SettingsText
    let appearance: AppearanceText
    let common: CommonText
    let home: HomeText
    let favorites: FavoritesText
    let drawer: DrawerText
    let learningList: LearningListText
    let learningMode: LearningModeText
    let progress: ProgressText
    let concepts: ConceptsText
    let detail: DetailText
    let challenge: ChallengeText
    let onboarding: OnboardingText
    let accessibility: AccessibilityText
    let info: InfoContent
}

struct TabText: Decodable {
    let learn: String
    let favorites: String
    let help: String
    let settings: String
}

struct SettingsText: Decodable {
    let title: String
    let languageSection: String
    let languagePicker: String
    let languageDE: String
    let languageEN: String
    let appearance: String
    let aboutSection: String
    let builtWith: String
    let system: String
}

struct AppearanceText: Decodable {
    let title: String
    let theme: String
    let system: String
    let light: String
    let dark: String
    let standard: String
}

struct CommonText: Decodable {
    let copy: String
    let copied: String
    let paste: String
    let clear: String
    let share: String
    let done: String
    let description: String
    let steps: String
    let codeExample: String
    let loadErrorTitle: String
    let loadErrorDescription: String
}

struct HomeText: Decodable {
    let title: String
}

struct FavoritesText: Decodable {
    let title: String
    let emptyTitle: String
    let emptyDescription: String
}

struct DrawerText: Decodable {
    let title: String
    let close: String
    let all: String
    let emptyTitle: String
    let emptyDescription: String
}

struct LearningListText: Decodable {
    let searchPlaceholder: String
    let all: String
    let emptyTitle: String
    let emptyDescription: String
}

struct LearningModeText: Decodable {
    let title: String
    let subtitle: String
    let allCards: String
    let tasks: String
    let cards: String
    let completed: String
    let practice: String
    let relatedCards: String
    let noTasks: String
}

struct ProgressText: Decodable {
    let title: String
    let unread: String
    let read: String
    let understood: String
    let review: String
    let markRead: String
    let markUnderstood: String
    let markReview: String
    let lastOpened: String
    let nextReview: String
}

struct ConceptsText: Decodable {
    let title: String
    let subtitle: String
    let searchPlaceholder: String
    let all: String
    let symbols: String
    let example: String
    let playground: String
    let reset: String
}

struct ChallengeText: Decodable {
    let yourCode: String
    let check: String
    let shareProgress: String
    let shareSolution: String
    let showHint: String
    let showSolution: String
    let solution: String
    let correctTitle: String
    let incorrectTitle: String
    let missingKeywords: String
    let taskLabel: String
    let languageLabel: String
    let statusLabel: String
    let myCodeLabel: String
}

struct DetailText: Decodable {
    let description: String
    let steps: String
    let codeExample: String
}

struct OnboardingText: Decodable {
    let pages: [OnboardingPageText]
    let next: String
    let start: String
    let skip: String
}

struct OnboardingPageText: Decodable {
    let title: String
    let text: String
}

struct AccessibilityText: Decodable {
    let openDrawer: String
    let closeDrawer: String
    let closeDrawerHint: String
    let settingsTitle: String
    let enhancedLabels: String
    let enhancedLabelsHint: String
    let reduceMotion: String
    let reduceMotionHint: String
    let largeCards: String
    let largeCardsHint: String
    let addFavorite: String
    let removeFavorite: String
    let favoriteStatus: String
    let notFavoriteStatus: String
    let categoryPrefix: String
    let favoriteHint: String
    let shareCode: String
    let learningCardHint: String
    let pasteInput: String
    let clearInput: String
    let copyOutput: String
    let shareOutput: String
}

extension Bundle {
    func appLocalizations() throws -> [String: AppLocalization] {
        guard let url = url(
            forResource: "app_localization",
            withExtension: "json"
        ) else {
            throw LocalizationLoadingError.missingResource
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw LocalizationLoadingError.unreadableResource(error)
        }

        do {
            return try JSONDecoder().decode(
                [String: AppLocalization].self,
                from: data
            )
        } catch {
            throw LocalizationLoadingError.invalidResource(error)
        }
    }
}
