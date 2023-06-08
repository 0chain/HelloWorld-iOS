//
//  AllocationActionStack.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI
import PhotosUI

struct AllocationActionStack: View {
    @EnvironmentObject var vultVM: VultViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingPicker = false
    var body: some View {
        HStack(spacing:10) {
            
               /* PhotosPicker(
                    selection: $vultVM.selectedPhotos,
                    matching: .images,
                    photoLibrary: .shared()) {
                        WalletActionBlock(icon: "photo",title: "Upload Image")
                    }*/
            
            WalletActionBlock(icon: "photo",title: "Upload Image")
                .onTapGesture {
                    isShowingPicker = true
                }
                .sheet(isPresented: $isShowingPicker) {
                                ImagePicker(selectedImages: $vultVM.selectedPhotos)
                            }
            WalletActionBlock(icon: "document",title: "Upload Document")
                .onTapGesture {
                    vultVM.presentDocumentPicker = true
                }
        }
        .aspectRatio(3.2, contentMode: .fit)
        .shadow(color: .init(white: colorScheme == .dark ? 0.05 : 0.95), radius: 100, x: 0, y: 0)
    }
}

struct AllocationActionStack_Previews: PreviewProvider {
    static var previews: some View {
        AllocationActionStack()
            .environmentObject(VultViewModel())
            .background(Color.gray.opacity(0.1))
            .previewLayout(.sizeThatFits)
    }
}

struct WalletActionBlock: View {
    var icon: String
    var title: String
    
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .center) {
                Image(icon)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: gr.size.width/2)
                Text(title)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.primary)
            .padding()
            .background(Color.background.opacity(0.9))
            .cornerRadius(12)
        }
    }
}


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
            /*for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self?.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }*/

            picker.dismiss(animated: true)
        }
    }
}
