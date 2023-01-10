//
//  ContentView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct CreateWalletView: View {
    @ObservedObject var zcncoreVM: ZcncoreManager
    @State var appear: Bool = false
    
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .center) {
                Spacer()
                Image("zus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: gr.size.width * (appear ? 0.75 : 0.5))
                Spacer()
                if appear {
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
                        } //ZStack
                    }
                    Spacer()
                }
            } //VStack
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 1)) {
                        self.appear = true
                    }
                }
            }
            .padding(appear ? 20 : 0)
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
        }//GR
    }
}

struct CreateWalletView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWalletView(zcncoreVM: .shared)
    }
}
