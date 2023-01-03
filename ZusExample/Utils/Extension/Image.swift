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
    func pngData() -> Data? {
        if let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let newRep = NSBitmapImageRep(cgImage: cgImage)
            newRep.size = self.size
            let pngData = newRep.representation(using: .png, properties: [:])
            return pngData
        }
        return nil
    }
    
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
    func setString(_ string: String?) {
        self.string = string ?? ""
    }
}
extension Image {
    convenience init(_ image: ZCNImage) {
        self.init(uiImage: image)
    }
}
#else
typealias PasteBoard = NSPasteboard
typealias ZCNImage = NSImage
extension NSPasteboard {
    func setString(_ string: String?) {
        self.declareTypes([.string], owner: nil)
        self.setString(string ?? "",forType:.string)
    }
}

extension Image {
    init(_ image: ZCNImage) {
        self.init(nsImage: image)
    }
}
#endif
