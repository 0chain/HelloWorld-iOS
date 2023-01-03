//
//  AllocationActionStack.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI
import PhotosUI

struct AllocationActionStack: View {
    @EnvironmentObject var vultVM: VultViewModel
    
    var body: some View {
        HStack(spacing:10) {
            WalletActionBlock(icon: "folder", "Create Folder")
            
            PhotosPicker(
                selection: $vultVM.selectedPhoto,
                matching: .images,
                photoLibrary: .shared()) {
                    WalletActionBlock(icon: "photo", "Upload Image")
                }
            
            WalletActionBlock(icon: "allocation", "Allocation Details")
        }
        .shadow(color: .init(white: 0.95), radius: 100, x: 0, y: 0)
    }
    
    @ViewBuilder func WalletActionBlock(icon: String,_ title:String) -> some View {
        GeometryReader { gr in
            VStack(alignment: .center) {
                Image(icon)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: gr.size.width/2)
                Text(title.split(separator: " ")[0])
                Text(title.split(separator: " ")[1])
            }
            .frame(height: gr.size.width * 1.33)
            .frame(maxWidth: .infinity)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.primary)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

struct AllocationActionStack_Previews: PreviewProvider {
    static var previews: some View {
        AllocationActionStack()
            .environmentObject(VultViewModel())
            .background(Color.gray.opacity(0.1))
    }
}
