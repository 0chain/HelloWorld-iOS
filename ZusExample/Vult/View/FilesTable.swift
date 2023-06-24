//
//  FilesTable.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI
import ZCNSwift

struct FilesTable: View {
    var didTapRow: (File) -> ()
    var didCopy: (File) -> ()
    var downloadFiles: ([File]) -> ()
    var files: Files
    @State var selectedFiles: [File] = []
    @State private var selecting = false
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("All Files").bold()
                Spacer()
                
                if selecting {
                    Button(action: {
                        self.downloadFiles(selectedFiles)
                        self.selecting = false
                        self.selectedFiles.removeAll()
                    }) {
                        Label("Confirm \(selectedFiles.count) download", systemImage: "arrow.down.circle.fill")
                    }
                    
                    Button(action: {
                        self.selecting = false
                        self.selectedFiles.removeAll()
                    }) {
                        Label("Cancel", systemImage: "arrow.down.circle.fill")
                    }
                    
                } else {
                    Button(action: {  self.selecting = true }) {
                        Label("Download", systemImage: "arrow.down.circle.fill")
                    }
                }
            }
           ScrollView(showsIndicators: false) {
                ForEach(files,id:\.id) { file in
                   FileRow(file: file, selecting: selecting, selectedFiles: $selectedFiles)
                        .contextMenu(menuItems: {
                            Button("Copy Auth Ticket") {
                                didCopy(file)
                            }
                        })
                    .id(file.id)
                    .onTapGesture {
                        if selecting {
                            if let index = selectedFiles.firstIndex(of: file) {
                                selectedFiles.remove(at: index)
                            } else {
                                selectedFiles.append(file)
                            }
                        } else {
                            self.didTapRow(file)
                        }
                    }
                }
            }
        }
    }
}

struct FilesTable_Previews: PreviewProvider {
    static var previews: some View {
        FilesTable(didTapRow: { _ in}, didCopy: {_ in}, downloadFiles: { _ in }, files: [File(name: "IMG_001.PNG", mimetype: "", path: "", lookupHash: "", type: "", size: 8378378399, numBlocks: 0, actualSize: 0, actualNumBlocks: 0, encryptionKey: "", createdAt: 0.0, updatedAt: 0.0, completedBytes: 0)])
    }
}

struct FileRow: View {
    var file: File
    var selecting: Bool
    @Binding var selectedFiles: [File]
    var body: some View {
        HStack(spacing: 20) {
            if selecting {
                if selectedFiles.contains(file) {
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Image(systemName: "circle")
                }
            }
            if let image = ZCNImage(contentsOfFile: file.localThumbnailPath.path) {
                Image(image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
            } else {
                Image(systemName: "doc.circle.fill")
                    .resizable()
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 38, height: 38)
                    .cornerRadius(8)
                    .foregroundColor(.teal)
            }
            
            Text(file.name)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
            
            Spacer()
            
            Text(file.fileSize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
            
            if !file.isDownloaded && file.isUploaded {
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
        .padding(.vertical,12)
        .padding(.horizontal,18)
        .background(Color.tertiarySystemBackground)
        .cornerRadius(12)
    }
}
