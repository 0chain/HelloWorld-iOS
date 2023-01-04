//
//  ContentView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct CreateWalletView: View {
    @ObservedObject var zcncoreVM: ZcncoreManager
    
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .center) {
                Spacer()
                Image("zus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: gr.size.width * 0.7)
                Spacer()
                Button(action: zcncoreVM.createWallet) {
                    ZStack(alignment: .trailing) {
                        Text(zcncoreVM.processTitle)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .bold()
                        
                        if zcncoreVM.processing {
                            ProgressView()
                                .padding(.trailing,50)
                                .tint(.white)
                        }
                    }
                }
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity)
        }
    }
}

struct CreateWalletView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWalletView(zcncoreVM: .shared)
    }
}
