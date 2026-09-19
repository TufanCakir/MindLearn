//
//  LearningProgressStatus.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation
import SwiftData
import SwiftUI

enum LearningProgressStatus: String, CaseIterable, Codable {
    case unread
    case read
    case understood
    case review

    var systemImage: String {
        switch self {
        case .unread: "circle"
        case .read: "book.closed"
        case .understood: "checkmark.seal.fill"
        case .review: "arrow.triangle.2.circlepath"
        }
    }

    var color: Color {
        switch self {
        case .unread: .secondary
        case .read: .blue
        case .understood: .green
        case .review: .orange
        }
    }
}

@Model
final class LearningProgress {
    @Attribute(.unique) var topicID: String
    var statusRaw: String
    var lastOpenedAt: Date?
    var completedAt: Date?
    var reviewCount: Int
    var nextReviewAt: Date?

    init(
        topicID: String,
        status: LearningProgressStatus = .unread,
        lastOpenedAt: Date? = nil,
        completedAt: Date? = nil,
        reviewCount: Int = 0,
        nextReviewAt: Date? = nil
    ) {
        self.topicID = topicID
        self.statusRaw = status.rawValue
        self.lastOpenedAt = lastOpenedAt
        self.completedAt = completedAt
        self.reviewCount = reviewCount
        self.nextReviewAt = nextReviewAt
    }

    var status: LearningProgressStatus {
        get { LearningProgressStatus(rawValue: statusRaw) ?? .unread }
        set { statusRaw = newValue.rawValue }
    }
}
