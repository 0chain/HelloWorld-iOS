//
//  AllocationDetailsBlock.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI

struct AllocationDetailsBlock: View {
    @EnvironmentObject var vultVM: VultViewModel
    
    var body: some View {
        HStack(spacing:20) {
            VStack(alignment: .leading) {
                Text(vultVM.allocation.name ?? "Allocation")
                    .font(.system(size: 14, weight: .semibold))
                Text(vultVM.allocation.expirationDate?.formattedUNIX ?? "")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }//VStack
            
            VStack(alignment: .leading) {
                ProgressView(value: vultVM.allocation.allocationFraction ?? 0.0)
                    .progressViewStyle(ZCNProgressStyle())
                    .frame(height: 10)
                
                Text("\(vultVM.allocation.usedSize?.formattedByteCount ?? "") used of \(vultVM.allocation.size?.formattedByteCount ?? "")")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }//VStack
        } //HStack
        .padding(.horizontal,16)
        .padding(.vertical,12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .init(white: 0.75), radius: 75, x: 0, y: 0)
    }
}

struct AllocationDetailsBlock_Previews: PreviewProvider {
    static var previews: some View {
        AllocationDetailsBlock()
            .environmentObject(VultViewModel())
            .previewLayout(.sizeThatFits)
    }
}
