//
//  ProgrammingLanguage.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

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

    var topicCategory: String {
        switch self {
        case .swiftUI: "SwiftUI"
        case .swift: "Swift"
        case .html: "HTML"
        case .json: "JSON"
        case .reactNative: "React Native"
        case .swiftData: "SwiftData"
        }
    }

    var taskFileName: String {
        switch self {
        case .swiftUI: "swiftUITasks"
        case .swift: "swiftTasks"
        case .html: "htmlTasks"
        case .json: "jsonTasks"
        case .reactNative: "reactNativeTasks"
        case .swiftData: "swiftDataTasks"
        }
    }
}
