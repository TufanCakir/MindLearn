import Foundation

enum ContentCategory: String, Codable, CaseIterable, Hashable {
    case arKit = "ARKit"
    case realityKit = "RealityKit"
    case spriteKit = "SpriteKit"
    case swiftUI = "SwiftUI"
    case swift = "Swift"
    case swiftData = "SwiftData"
    case metal = "Metal"
    case vision = "Vision"
    case widgetKit = "WidgetKit"
    case healthKit = "HealthKit"
    case speech = "Speech"
    case html = "HTML"
    case json = "JSON"
    case reactNative = "React Native"
    case school = "School"
    case children = "Children"
    case completely = "Completely"
    case general = "General"
}

/// The UI-independent shape shared by MindLearn learning units.
/// Stable IDs also provide a foundation for deep links and ClassKit contexts.
protocol LearningContent: Codable {
    var id: String { get }
    var title: LocalizedTaskText { get }
    var description: LocalizedTaskText { get }
    var icon: String? { get }
    var steps: [LocalizedTaskText] { get }
    var code: String { get }
    var category: ContentCategory { get }
}

extension LearningContent {
    func title(language: String) -> String {
        title.value(for: language)
    }

    func description(language: String) -> String {
        description.value(for: language)
    }

    func steps(language: String) -> [String] {
        steps.map { $0.value(for: language) }
    }
}
