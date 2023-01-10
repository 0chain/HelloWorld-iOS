//
//  Bundle.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 04/01/23.
//

import Foundation

extension Bundle {

    /// Release version number
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// Build version number
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
    // Application version
    var applicationVersion: String {
        return "v\(releaseVersionNumber ?? "") ( \(buildVersionNumber ?? "") )"
    }
}
