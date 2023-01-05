//
//  Bundle.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 04/01/23.
//

import Foundation

extension Bundle {

    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
    var applicationVersion: String {
        return "v\(releaseVersionNumber ?? "") ( \(buildVersionNumber ?? "") )"
    }
}
