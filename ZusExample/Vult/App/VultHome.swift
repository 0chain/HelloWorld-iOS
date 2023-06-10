//
//  VultHome.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import SwiftUI
import PhotosUI
import ZCNSwift

struct VultHome: View {
    @EnvironmentObject var vultVM: VultViewModel
    
    var body: some View {
        GeometryReader { gr in
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    AllocationDetailsBlock()
                    
                    AllocationActionStack()
                    
                    FilesTable()
                    
                    if #available(iOS 16.0, *) {
                        NavigationLink(destination: PreviewController(files: vultVM.files,file: vultVM.selectedFile).navigationTitle(Text(vultVM.selectedFile?.name ?? "")) .navigationBarTitleDisplayMode(.inline)
                            .navigationDocument(vultVM.selectedFile?.localThumbnailPath ?? URL(fileURLWithPath: ""))
                                       ,isActive: $vultVM.openFile) {
                            EmptyView()
                        }
                    } else {
                        NavigationLink(destination: PreviewController(files: vultVM.files,file: vultVM.selectedFile).navigationTitle(Text(vultVM.selectedFile?.name ?? "")) .navigationBarTitleDisplayMode(.inline)
                                       ,isActive: $vultVM.openFile) {
                            EmptyView()
                        }
                    }
                }
                if vultVM.presentPopup {
                    ZCNToast(type: vultVM.popup,presented: $vultVM.presentPopup)
                }
            }
            .padding(22)
        }
        .task{ await vultVM.listDir() }
        .navigationTitle(Text("Vult"))
        .navigationBarTitleDisplayMode(.large)
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $vultVM.presentAllocationDetails) { AllocationDetailsView(allocation: vultVM.allocation) }
        .sheet(isPresented: $vultVM.isShowingPicker) { ImagePicker(selectedImages: $vultVM.selectedPhotos)}
        .fileImporter(isPresented: $vultVM.presentDocumentPicker, allowedContentTypes: [.image,.pdf,.audio],onCompletion: vultVM.uploadDocument)
        .onChange(of: vultVM.selectedPhotos, perform: vultVM.uploadImage)
        .environmentObject(vultVM)
    }
}

struct VultHome_Previews: PreviewProvider {
    static var previews: some View {
        let vm : VultViewModel = {
            let vm = VultViewModel()
            vm.files = [File(name: "IMG_001.PNG", mimetype: "", path: "", lookupHash: "", type: "", size: 8378378399, numBlocks: 0, actualSize: 0, actualNumBlocks: 0, encryptionKey: "", createdAt: 0.0, updatedAt: 0.0, completedBytes: 0)]
            return vm
        }()
        
        VultHome()
            .environmentObject(vm)
    }
}
