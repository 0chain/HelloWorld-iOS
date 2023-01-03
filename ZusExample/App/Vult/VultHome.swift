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
                
                Text("All Files").bold()
                
                ScrollView(showsIndicators: false) {
                    ForEach(vultVM.files) { file in
                        FileRow(file: file)
                    }
                }
            }
            .padding(22)
        }
        .onAppear(perform: vultVM.listDir)
        .background(Color.gray.opacity(0.1))
        .onChange(of: vultVM.selectedPhoto, perform: vultVM.uploadImage)
        .environmentObject(vultVM)
    }
}

struct VultHome_Previews: PreviewProvider {
    static var previews: some View {
        VultHome()
    }
}
