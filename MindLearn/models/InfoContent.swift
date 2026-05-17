//
//  InfoContent.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import Foundation

struct InfoContent: Decodable {
    let title: String
    let subtitle: String
    let sections: [InfoSection]
}

struct InfoSection: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let text: String

    private enum CodingKeys: String, CodingKey {
        case title
        case text
    }
}
