//
//  DocumentPicker.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import Foundation
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var filePath: URL?
    
    /// Make Coordinator
    /// - Returns: Coordinator of preview view controller data source
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent: self)
    }
    
    /// Make UI Viewcotroller
    /// - Parameter context: A context structure containing information about the current state of the system.
    /// - Returns: Preview of view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    /// Update of view controller
    /// - Parameters:
    ///   - uiViewController: uiViewController of document picker type
    ///   - context: A context structure containing information about the current state of the system.
    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentPicker
        /// Initialize parent view controller
        /// - Parameter parent: parent view controller of document picker
        init(parent: DocumentPicker){
            self.parent = parent
        }
        /// Document picker
        /// - Parameters:
        ///   - controller: controller of document picker
        ///   - urls: urls of file paths
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.filePath = urls[0]
            print(urls[0].absoluteString)
        }
    }
}
