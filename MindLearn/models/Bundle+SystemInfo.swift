//
//  Bundle+SystemInfo.swift
//  MindLearn
//
//  Created by Tufan Cakir on 24.02.26.
//

import UIKit

extension Bundle {

    // MARK: iOS Version

    static var systemVersion: String {

        UIDevice.current.systemVersion
    }

    // MARK: Device Name

    static var deviceModel: String {

        UIDevice.current.model
    }

    // MARK: System Name

    static var systemName: String {

        UIDevice.current.systemName
    }

    // MARK: Compatibility

    static var compatibility: String {

        let version =
        ProcessInfo.processInfo.operatingSystemVersion

        if version.majorVersion >= 17 {
            return "Optimal"
        }

        if version.majorVersion >= 16 {
            return "Kompatibel"
        }

        return "Eingeschränkt"
    }
}
