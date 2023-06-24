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
    @ObservedObject var vultVM: VultViewModel
    
    var body: some View {
        VStack {
            
            AllocationDetailsBlock(allocation: vultVM.allocation)
            
            AllocationActionStack(didSelectPhotos: vultVM.uploadImage(selectedPhotos:),
                                  didSelectDocuments: vultVM.uploadDocument(result:))
            
            FilesTable(didTapRow: vultVM.didTapRow(file:),
                       didCopy: vultVM.copyAuthToken(file:),
                       downloadFiles: vultVM.downloadImage(file:),
                       files: vultVM.files)
            
            FilePreviewViewNavigation()
        }
        .toast(presented: $vultVM.presentPopup, type: vultVM.popup)
        .padding(22)
        .task{ await vultVM.listDir() }
        .navigationTitle(Text("Vult"))
        .navigationBarTitleDisplayMode(.large)
        .background(Color.gray.opacity(0.1))
    }
    
    @ViewBuilder func FilePreviewViewNavigation() -> some View {
        NavigationLink(destination: FilePreviewView(files: vultVM.files, file: vultVM.selectedFile), isActive: $vultVM.openFile) {
            EmptyView()
        }
    }
}

struct VultHome_Previews: PreviewProvider {
    static var previews: some View {
        let vm : VultViewModel = {
            let vm = VultViewModel()
            vm.files = [File(name: "IMG_001.PNG", mimetype: "", path: "", lookupHash: "", type: "", size: 8378378399, numBlocks: 0, actualSize: 0, actualNumBlocks: 0, encryptionKey: "", createdAt: 0.0, updatedAt: 0.0, completedBytes: 0)]
            return vm
        }()
        
        NavigationView {
            VultHome(vultVM: vm)
        }
    }
}
