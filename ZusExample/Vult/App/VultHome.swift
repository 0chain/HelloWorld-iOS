//
//  VultHome.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import SwiftUI
import PhotosUI

struct VultHome: View {
    @EnvironmentObject var vultVM: VultViewModel
    
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .leading) {
                AllocationDetailsBlock()
                
                AllocationActionStack()
                
                FilesTable()
                
                NavigationLink(destination: PreviewController(files: vultVM.files,file: vultVM.selectedFile).navigationTitle(Text(vultVM.selectedFile?.name ?? "")) .navigationBarTitleDisplayMode(.inline).navigationDocument(vultVM.selectedFile?.localThumbnailPath ?? URL(fileURLWithPath: ""))
,isActive: $vultVM.openFile) {
                    EmptyView()
                }
            } //VStack
            .padding(22)
        } //GR
        .onAppear(perform: vultVM.listDir)
        .navigationTitle(Text("Vult"))
        .navigationBarTitleDisplayMode(.large)
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $vultVM.presentAllocationDetails) { AllocationDetailsView(allocation: vultVM.allocation) }
        .fileImporter(isPresented: $vultVM.presentDocumentPicker, allowedContentTypes: [.image,.pdf,.audio],onCompletion: vultVM.uploadDocument)
        .onChange(of: vultVM.selectedPhoto, perform: vultVM.uploadImage)
        .environmentObject(vultVM)
    }
}

struct VultHome_Previews: PreviewProvider {
    static var previews: some View {
        VultHome()
    }
}
