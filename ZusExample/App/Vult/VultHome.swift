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
                
                NavigationLink(destination: PreviewController(files: vultVM.files,file: vultVM.selectedFile),isActive: $vultVM.openFile) {
                    EmptyView()
                }
            }
            .padding(22)
        }
        .onAppear(perform: vultVM.listDir)
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $vultVM.presentAllocationDetails) { AllocationDetailsView(allocation: vultVM.allocation) }
        .sheet(isPresented: $vultVM.presentDocumentPicker) { DocumentPicker(filePath: $vultVM.selectedDocument) }
        .onChange(of: vultVM.selectedPhoto, perform: vultVM.uploadImage)
        .onChange(of: vultVM.selectedDocument, perform: vultVM.uploadDocument)
        .environmentObject(vultVM)
    }
}

struct VultHome_Previews: PreviewProvider {
    static var previews: some View {
        VultHome()
    }
}
