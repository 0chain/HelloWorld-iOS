//
//  VultHome.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import SwiftUI
import PhotosUI

struct VultHome: View {
    @StateObject var vultVM: VultViewModel = VultViewModel()
    
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
        .onChange(of: vultVM.selectedPhoto, perform: vultVM.uploadImage)
        .environmentObject(vultVM)
    }
}

struct VultHome_Previews: PreviewProvider {
    static var previews: some View {
        VultHome()
    }
}
