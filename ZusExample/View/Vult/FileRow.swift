//
//  FileRow.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI

struct FileRow: View {
    @State var file: File
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
            
            Spacer()
            
            Text(file.fileSize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.vertical,12)
        .padding(.horizontal,18)
        .background(.white)
        .cornerRadius(12)
    }
}

struct FileRow_Previews: PreviewProvider {
    static var previews: some View {
        FileRow(file: File(name: "IMG", mimetype: "", path: "", lookupHash: "", type: "", size: 0, numBlocks: 0, actualSize: 0, actualNumBlocks: 0, encryptionKey: "", createdAt: 0, updatedAt: 0.0, completedBytes: 0))
            .padding()
            .background(.black)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}
