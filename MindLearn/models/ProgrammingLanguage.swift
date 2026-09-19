//
//  ProgrammingLanguage.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

enum ContentLanguage: String, Codable, CaseIterable, Identifiable {
    case swiftUI = "SwiftUI"
    case swift = "Swift"
    case html = "HTML"
    case json = "JSON"
    case reactNative = "React Native"
    case swiftData = "SwiftData"
    case general = "General"

    var id: String { rawValue }
}

enum ProgrammingLanguage: String, CaseIterable, Identifiable, Codable {
    case swiftUI
    case swift
    case html
    case json
    case reactNative
    case swiftData

    var id: String { rawValue }

    var title: String {
        switch self {
        case .swiftUI: "SwiftUI"
        case .swift: "Swift"
        case .html: "HTML"
        case .json: "JSON"
        case .reactNative: "React Native"
        case .swiftData: "SwiftData"
        }
    }

    var icon: String {
        switch self {
        case .swiftUI: "swift"
        case .swift: "swift"
        case .html: "chevron.left.forwardslash.chevron.right"
        case .json: "curlybraces"
        case .reactNative: "atom"
        case .swiftData: "swiftdata"
        }
    }

    var topicCategory: ContentCategory {
        switch self {
        case .swiftUI: .swiftUI
        case .swift: .swift
        case .html: .html
        case .json: .json
        case .reactNative: .reactNative
        case .swiftData: .swiftData
        }
    }

    var taskFile: CodingTaskFile {
        switch self {
        case .swiftUI: .swiftUI
        case .swift: .swift
        case .html: .html
        case .json: .json
        case .reactNative: .reactNative
        case .swiftData: .swiftData
        }
    }

    var contentLanguage: ContentLanguage {
        switch self {
        case .swiftUI: .swiftUI
        case .swift: .swift
        case .html: .html
        case .json: .json
        case .reactNative: .reactNative
        case .swiftData: .swiftData
        }
    }
}
