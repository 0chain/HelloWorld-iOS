//
//  AppSelectionView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct AppSelectionView: View {
    @State var present:Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { gr in
                VStack(alignment: .center,spacing: 20) {
                    Spacer()
                    AppSelectionBox(icon: "bolt",width: gr.size.width * 0.7)
                        .destination(destination: BoltHome())
                    
                    Spacer()
                    AppSelectionBox(icon: "vult",width: gr.size.width * 0.7)
                        .destination(destination: BoltHome())
                    
                    Spacer()
                    
                    WalletDetailsBlock(wallet: Utils.wallet!,width: gr.size.width * 0.7)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(gr.size.width/15)
            }
        }
    }
    
    @ViewBuilder func AppSelectionBox(icon: String,width:CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(.background).frame(maxWidth: .infinity).shadow(radius: 5)
            
            Image(icon)
                .resizable()
                .aspectRatio(2, contentMode: .fit)
                .padding(width/10)
        }
    }
    
    
    @ViewBuilder func WalletDetailsBlock(wallet: Wallet,width:CGFloat) -> some View  {

        VStack(alignment: .leading,spacing: 20) {
            HStack {
                Text("Wallet Details")
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(present ? 90.0 : 0.0))
            }
            if present {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading,spacing: 10) {
                        self.row(title: "Client ID: ", text: wallet.client_id)
                        self.row(title: "Client Key: ", text: wallet.client_key)
                        self.row(title: "Private Key: ", text: wallet.keys.first?.private_key ?? "")
                        self.row(title: "Public Key: ", text: wallet.keys.first?.public_key ?? "")
                        self.row(title: "Mnemonics: ", text: wallet.mnemonics)
                    }
                }
            }
        }
        .padding(width/10)
        .background(RoundedRectangle(cornerRadius: 16).fill(.background).shadow(radius: 5))
        .onTapGesture {
            withAnimation {
                self.present.toggle()
            }
        }
    }
    
    @ViewBuilder func row(title:String,text:String) -> some View {
        HStack {
            Text(title)
            Text(text)
        }
    }
}

struct AppSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppSelectionView()
    }
}
