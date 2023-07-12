//
//  AllocationActionStack.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI
import PhotosUI

struct AllocationActionStack: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var presentDocumentPicker: Bool = false
    @State private var selectedPhotos: [PHPickerResult] = []
    var didSelectPhotos: ([PHPickerResult]) -> ()
    var didSelectDocuments: (Result<URL, Error>) -> ()
    
    var body: some View {
        HStack(spacing:10) {
            
            WalletActionBlock(icon: "photo",title: "Upload Image")
                .sheet(destination: ImagePicker(selectedImages: $selectedPhotos))
                
            WalletActionBlock(icon: "document",title: "Upload Document")
                .tapToggle($presentDocumentPicker)
            
        }
        .aspectRatio(3.2, contentMode: .fit)
        .shadow(color: .init(white: colorScheme == .dark ? 0.05 : 0.95), radius: 100, x: 0, y: 0)
        .onChange(of: selectedPhotos, perform: didSelectPhotos)
        .fileImporter(isPresented: $presentDocumentPicker, allowedContentTypes: [.image,.pdf,.audio],onCompletion: didSelectDocuments)
    }
}

struct AllocationActionStack_Previews: PreviewProvider {
    static var previews: some View {
        AllocationActionStack(didSelectPhotos: {_ in }, didSelectDocuments: { _ in })
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
