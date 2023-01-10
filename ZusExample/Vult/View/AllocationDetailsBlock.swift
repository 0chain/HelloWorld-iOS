//
//  AllocationDetailsBlock.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI

struct AllocationDetailsBlock: View {
    @EnvironmentObject var vultVM: VultViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
            HStack(spacing:20) {
                VStack(alignment: .leading) {
                    Text(vultVM.allocation.defaultName)
                        .font(.system(size: 14, weight: .semibold))
                    Text(vultVM.allocation.expirationDate?.formattedUNIX ?? "")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                } //VStack
                
                VStack(alignment: .leading) {
                    ProgressView(value: vultVM.allocation.allocationFraction)
                        .progressViewStyle(ZCNProgressStyle())
                        .frame(height: 10)
                    
                    Text("\(vultVM.allocation.usedSize?.formattedByteCount ?? "") used of \(vultVM.allocation.size?.formattedByteCount ?? "") (\(vultVM.allocation.allocationPercentage)%)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                } //VStack
        } //HStack
        .padding(.horizontal,16)
        .padding(.vertical,12)
        .background(Color.tertiarySystemBackground)
        .cornerRadius(12)
        .shadow(color: .init(white: colorScheme == .dark ? 0.25 : 0.75), radius: 100, x: 0, y: 0)
    }
}

struct AllocationDetailsBlock_Previews: PreviewProvider {
    static var previews: some View {
        AllocationDetailsBlock()
            .environmentObject(VultViewModel())
            .previewLayout(.sizeThatFits)
    }
}
