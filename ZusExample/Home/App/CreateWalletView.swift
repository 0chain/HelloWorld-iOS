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
            ZStack(alignment: .center) {
                Spacer()
                Image("zus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: gr.size.width * 0.5)
                    .offset(y:-150)
                    Button(action: zcncoreVM.createWallet) {
                        ZStack(alignment: .trailing) {
                            Text("Create Wallet")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(LinearGradient.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .disabled(zcncoreVM.processing)
                                .opacity(zcncoreVM.processing ? 0.5 : 1)
                        }
                    }
                    .offset(y:100)
                
                if zcncoreVM.processing {
                    ZCNToast(type: zcncoreVM.toast, presented: $zcncoreVM.processing,autoDismiss: false)
                        .frame(maxHeight: .infinity,alignment: .bottom)
                        .padding(.vertical,50)
                        .animation(.easeIn,value: 10)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color.background)
    }
}

struct CreateWalletView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWalletView(zcncoreVM: .init())
    }
}
