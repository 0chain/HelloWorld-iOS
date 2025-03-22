//
//  AllocationDetailsBlock.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI
import ZCNSwift

struct AllocationDetailsBlock: View {
    var allocation: Allocation
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
            HStack(spacing:20) {
                VStack(alignment: .leading) {
                    Text(allocation.defaultName)
                        .font(.system(size: 14, weight: .semibold))
                    Text(allocation.expirationDate.formattedUNIX)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading) {
                    ProgressView(value: allocation.allocationFraction)
                        .progressViewStyle(ZCNProgressStyle())
                        .frame(height: 10)
                    
                    Text("\(allocation.stats.usedSize.formattedByteCount) used of \(allocation.size.formattedByteCount) (\(allocation.allocationPercentage)%)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
        }
        .padding(.horizontal,16)
        .padding(.vertical,12)
        .background(Color.tertiarySystemBackground)
        .cornerRadius(12)
        .shadow(color: .init(white: colorScheme == .dark ? 0.25 : 0.75), radius: 100, x: 0, y: 0)
    }
}

struct AllocationDetailsBlock_Previews: PreviewProvider {
    static var previews: some View {
        AllocationDetailsBlock(allocation: .default)
            .environmentObject(VultViewModel())
            .previewLayout(.sizeThatFits)
    }
}
