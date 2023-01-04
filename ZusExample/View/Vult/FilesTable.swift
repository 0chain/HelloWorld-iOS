//
//  FilesTable.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI

struct FilesTable: View {
    @EnvironmentObject var vultVM: VultViewModel
    @State var previewFile:Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("All Files").bold()
            
            ScrollView(showsIndicators: false) {
                ForEach($vultVM.files) { file in
                    FileRow(file: file)
                }
            }
        }
    }
    
}

struct FilesTable_Previews: PreviewProvider {
    static var previews: some View {
        let vm : VultViewModel = {
            let vm = VultViewModel()
            vm.files = [File(name: "IMG_001.PNG", mimetype: "", path: "", lookupHash: "", type: "", size: 8378378399, numBlocks: 0, actualSize: 0, actualNumBlocks: 0, encryptionKey: "", createdAt: 0.0, updatedAt: 0.0, completedBytes: 0)]
            return vm
        }()
        
        FilesTable()
            .environmentObject(vm)
    }
}

struct FileRow: View {
    @Binding var file: File
    var body: some View {
        HStack(spacing: 20) {
            if let image = ZCNImage(contentsOfFile: file.localThumbnailPath.path) {
                Image(image)
                    .resizable()
                    .frame(width: 40, height: 40)
            } else {
                Image("sample")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .cornerRadius(8)
            }
            Text(file.name)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
            
            Spacer()
            
            Text(file.fileSize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
            
            if !file.isDownloaded && file.isUploaded {
                Button {
                  //  vultVM.downloadImage(file: file)
                } label: {
                    VStack(alignment: .center,spacing: 3) {
                        Image(systemName: "arrow.down.to.line.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .symbolRenderingMode(file.status == .progress ? .monochrome : .hierarchical)
                        
                        if file.status == .progress {
                            Text(file.fileDownloadPercent)
                                .font(.system(size: 8))
                        }
                    }
                    .foregroundColor(.teal)
                }
            }
        }
        .padding(.vertical,12)
        .padding(.horizontal,18)
        .background(.white)
        .cornerRadius(12)
        .onTapGesture {
            if file.isDownloaded {
             //   self.vultVM.openFile = true
              //  self.vultVM.selectedFile = file
            }
        }
    }
}
