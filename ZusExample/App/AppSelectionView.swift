//
//  AppSelectionView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct AppSelectionView: View {
    @State var presentWalletDetails : Bool = false
    @State var presentVultHome: Bool = false
    
    @EnvironmentObject var zcncoreVM: ZcncoreManager
    
    @StateObject var boltVM: BoltViewModel = BoltViewModel()
    @StateObject var vultVM: VultViewModel = VultViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { gr in
                VStack(alignment: .center,spacing: 20) {
                    Spacer()
                    AppSelectionBox(icon: "bolt",width: gr.size.width * 0.7)
                        .destination(destination: BoltHome().environmentObject(boltVM))
                    
                    Spacer()
                    AppSelectionBox(icon: "vult",width: gr.size.width * 0.7)
                        .destination(destination: VultHome().environmentObject(vultVM))
                    
                    Spacer()
                    
                    WalletDetailsBlock(wallet: Utils.wallet!,width: gr.size.width * 0.7)
                    
                    Spacer()
                } //VStack
                .frame(maxWidth: .infinity)
                .padding(gr.size.width/15)
            } //GR
        } //NavigationView
    }
    
    @ViewBuilder func AppSelectionBox(icon: String,width:CGFloat,allocationButton:Bool = false) -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(width/10)
                    .opacity(allocationButton ? 0.5 : 1)
                
                if allocationButton {
                    Text("Create Allocation")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(3)
                        .background(.blue)
                }
            } //VStack
        } // ZStack
        .frame(maxWidth: .infinity)
        .background(.background)
        .aspectRatio(2,contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16)).shadow(radius: 5)
    }
    
    
    @ViewBuilder func WalletDetailsBlock(wallet: Wallet,width:CGFloat) -> some View  {
        
        VStack(alignment: .leading,spacing: 20) {
            HStack {
                Text("Wallet Details")
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(presentWalletDetails ? 90.0 : 0.0))
            } //HStack
            if presentWalletDetails {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading,spacing: 10) {
                        self.row(title: "Client ID: ", text: wallet.client_id)
                        self.row(title: "Client Key: ", text: wallet.client_key)
                        self.row(title: "Private Key: ", text: wallet.keys.first?.private_key ?? "")
                        self.row(title: "Public Key: ", text: wallet.keys.first?.public_key ?? "")
                        self.row(title: "Mnemonics: ", text: wallet.mnemonics)
                    } //VStack
                } //ScrollView
            }
        } //VStack
        .padding(width/10)
        .background(RoundedRectangle(cornerRadius: 16).fill(.background).shadow(radius: 5))
        .onTapGesture {
            withAnimation {
                self.presentWalletDetails.toggle()
            }
        }
    }
    
    @ViewBuilder func row(title:String,text:String) -> some View {
        HStack {
            Text(title)
            Text(text)
        } //HStack
    }
}

struct AppSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let previewDefaults: UserDefaults = {
            let defaults = UserDefaults.standard
            let wallet = Wallet.init(client_id: "8378938937893893639", client_key: "397397639837", keys: [], mnemonics: "", version: "")
            let data = try? JSONEncoder().encode(wallet)
            defaults.set(data, forKey: Utils.UserDefaultsKey.wallet.rawValue)
            defaults.set("", forKey: Utils.UserDefaultsKey.allocationID.rawValue)
            return defaults
        }()
        
        AppSelectionView()
            .environmentObject(ZcncoreManager())
            .defaultAppStorage(previewDefaults)
    }
}
