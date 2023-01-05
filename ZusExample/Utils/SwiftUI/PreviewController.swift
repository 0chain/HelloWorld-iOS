//
//  PreviewController.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI
import QuickLook

struct PreviewController: UIViewControllerRepresentable {
    var files: Files
    var file: File?
    /// Make UI Viewcotroller
    /// - Parameter context: A context structure containing information about the current state of the system.
    /// - Returns: Preview of view controller
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        if let file = file {
            controller.currentPreviewItemIndex = files.filter(\.isDownloaded).firstIndex(of: file) ?? 0
        }
        return controller
    }
    
    /// Update of view controller
    func updateUIViewController(
        _ uiViewController: QLPreviewController, context: Context) { }
    
    /// Make Coordinator
    /// - Returns: Coordinator of preview view controller data source
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: QLPreviewControllerDataSource {
        
        let parent: PreviewController
        
        /// Initialize parent view controller
        /// - Parameter parent: parent view controller
        init(parent: PreviewController) {
            self.parent = parent
        }
        
        /// Number of preview items
        /// - Parameter controller: controller of preview view controller
        /// - Returns: number of items
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return parent.files.filter(\.isDownloaded).count
        }
        
        /// Preview viewCotroller
        /// - Parameters:
        ///   - controller: controller of view controller
        ///   - index: index number of view controller
        /// - Returns: Items for the Preview Controller
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            
            guard let CacheDirURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
                print("Can't get cache dir URL")
                return NSURL(fileURLWithPath: "FILE_NOT_FOUND")
            }
            
            let url = parent.files.filter(\.isDownloaded)[index].localFilePath
            
            let component = url.pathComponents.last ?? "img.png"
            let fileUrl = CacheDirURL.appendingPathComponent(component)
            
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                try? FileManager.default.copyItem(at: url, to: fileUrl)
            }
            
            return NSURL(fileURLWithPath: fileUrl.path)
            
        }
        
    }
}
