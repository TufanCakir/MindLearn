//
//  DrawerSection.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct DrawerSection: LearningContent, Identifiable {

    let id: String
    let title: LocalizedTaskText
    let description: LocalizedTaskText
    let icon: String?

    let steps: [LocalizedTaskText]

    let colors: DrawerColor

    let code: String

    let category: ContentCategory

}

struct DrawerColor: Codable {

    let backgroundColors: [String]
    let textColors: [String]
}

// MARK: - JSON Files (Typsicher)

enum DrawerDataFile: String, CaseIterable {

    case swiftUI = "drawerSwiftUIData"
    case swiftData = "drawerSwiftData"
    case swiftDataModel = "drawerSwiftDataModel"
    case metal = "drawerMetalData"
    case realityKit = "drawerRealityKitData"
    case spriteKit = "drawerSpriteKitData"
    case arKit = "drawerARKitData"
    case widgetKit = "drawerWidgetKitData"
    case healthKit = "drawerHealthKitData"
    case vision = "drawerVisionData"
    case speech = "drawerSpeechData"
    case html = "drawerHtmlData"
}

// MARK: - Loader Service

@MainActor
protocol DrawerSectionProviding {
    func loadAllSections() throws -> [DrawerSection]
}

@MainActor
final class DrawerSectionLoader: DrawerSectionProviding {
    static let shared = DrawerSectionLoader()

    private let repository: BundleContentRepository<DrawerSection, DrawerDataFile>

    convenience init() {
        self.init(repository: BundleContentRepository())
    }

    init(repository: BundleContentRepository<DrawerSection, DrawerDataFile>) {
        self.repository = repository
    }

    func load(_ file: DrawerDataFile) throws -> [DrawerSection] {
        try repository.load(file)
    }

    func loadAll(_ files: [DrawerDataFile]) throws -> [DrawerSection] {
        try repository.loadAll(files)
    }

    func loadAllSections() throws -> [DrawerSection] {
        try loadAll(DrawerDataFile.allCases)
    }
}
