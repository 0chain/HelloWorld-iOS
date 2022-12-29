//
//  AvailableBalanceBlock.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import SwiftUI

struct AvailableBalanceBlock: View {
    @EnvironmentObject var boltVM: BoltViewModel
    
    var body: some View {
        VStack(alignment:.leading,spacing: 10) {
            
            Text("Available Balance")
                .font(.system(size: 14, weight: .regular))
            
            HStack(alignment:.bottom,spacing:0) {
                Text("\(boltVM.balance)")
                    .font(.system(size: 36, weight: .bold))
                Text(" ZCN")
                    .font(.system(size: 14, weight: .regular))
                    .padding(.bottom, 8)
            }
            .padding(.top,-10)
            
            HStack {
                Text("Total Balance")
                    .font(.system(size: 16, weight: .regular))
                Text(boltVM.balanceUSD)
                    .font(.system(size: 16, weight: .bold))
            }
        }
    }
}

struct AvailableBalanceBlock_Previews: PreviewProvider {
    static var previews: some View {
        AvailableBalanceBlock()
            .environmentObject(BoltViewModel())
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}

