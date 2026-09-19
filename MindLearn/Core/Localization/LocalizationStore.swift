import Foundation
import Observation

@MainActor
@Observable
final class LocalizationStore {
    static let languageKey = "language"

    var language: String {
        didSet {
            guard language != oldValue else { return }
            defaults.set(language, forKey: Self.languageKey)
        }
    }

    var text: AppLocalization {
        localizations[language] ?? fallbackLocalization
    }

    var locale: Locale {
        Locale(identifier: language)
    }

    private let defaults: UserDefaults
    private let localizations: [String: AppLocalization]
    private let fallbackLocalization: AppLocalization

    init(
        defaults: UserDefaults = .standard,
        bundle: Bundle = .main
    ) throws {
        let localizations = try bundle.appLocalizations()
        guard let fallbackLocalization = localizations["en"] else {
            throw LocalizationLoadingError.missingFallbackLanguage
        }

        self.defaults = defaults
        self.localizations = localizations
        self.fallbackLocalization = fallbackLocalization
        let preferredLanguage = defaults.string(forKey: Self.languageKey)
            ?? Locale.current.language.languageCode?.identifier
            ?? "en"
        language = ["de", "en"].contains(preferredLanguage)
            ? preferredLanguage
            : "en"
    }
}
