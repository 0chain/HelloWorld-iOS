//
//  ImagePicker.swift
//  ZusExample
//
//  Created by Vijay Kachhadiya on 09/06/23.
//


import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [PHPickerResult]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 10
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll()
            parent.selectedImages = results
            picker.dismiss(animated: true)
        }
    }
}
