//
//  Color+Hex.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

extension Color {

    init?(hex: String?) {

        guard var hex else { return nil }

        hex = hex.replacingOccurrences(of: "#", with: "")

        var int: UInt64 = 0

        guard
            Scanner(string: hex)
                .scanHexInt64(&int)
        else { return nil }

        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255

        self.init(.sRGB, red: r, green: g, blue: b)
    }
}
