//
//  Image.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import Foundation
import SwiftUI

#if canImport(AppKit)
extension NSImage {
    /// PNG Image convet with Data
    /// - Returns: image in data format
    func pngData() -> Data? {
        if let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let newRep = NSBitmapImageRep(cgImage: cgImage)
            newRep.size = self.size
            let pngData = newRep.representation(using: .png, properties: [:])
            return pngData
        }
        return nil
    }
    
    /// JPEG Image convet with Data
    /// - Parameter compressionQuality: Compression Quality of image
    /// - Returns: image in data format
    func jpegData(compressionQuality:CGFloat) -> Data? {
        if let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
            let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [.compressionFactor:compressionQuality])
            return jpegData
        }
        return nil
    }
}
#endif


#if os(iOS)
typealias PasteBoard = UIPasteboard
typealias ZCNImage = UIImage
extension UIPasteboard {
    /// Set string in pasteboard
    /// - Parameter string: copied string
    func setString(_ string: String?) {
        self.string = string ?? ""
    }
}
extension Image {
    /// Initialize Image
    /// - Parameter image: zcnImage with image
    init(_ image: ZCNImage) {
        self.init(uiImage: image)
    }
}
#else
typealias PasteBoard = NSPasteboard
typealias ZCNImage = NSImage
extension NSPasteboard {
    /// Set string in pasteboard
    /// - Parameter string: copied string
    func setString(_ string: String?) {
        self.declareTypes([.string], owner: nil)
        self.setString(string ?? "",forType:.string)
    }
}

extension Image {
    /// Initialize Image
    /// - Parameter image: zcnImage with image
    init(_ image: ZCNImage) {
        self.init(nsImage: image)
    }
}
#endif
