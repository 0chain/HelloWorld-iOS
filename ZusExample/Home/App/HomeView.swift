//
//  AppSelectionView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct HomeView: View {
    @State var presentWalletDetails : Bool = false
    @State var presentVultHome: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var boltVM: BoltViewModel = BoltViewModel()
    @StateObject var vultVM: VultViewModel = VultViewModel()
    @StateObject var homeVM: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { gr in
                VStack(alignment: .center,spacing: 20) {
                    HStack(spacing: 15) {
                        WalletActionBlock(icon: "wallet", title: "Wallet Details")
                            .onTapGesture {
                                homeVM.presentWalletDetails()
                            }
                        WalletActionBlock(icon: "allocation", title: "Allocation Details")
                            .onTapGesture {
                                homeVM.presentAllocationDetails()
                            }
                        
                        WalletActionBlock(icon: "network", title: "Network Details")
                            .onTapGesture {
                                homeVM.presentNetworkDetails()
                            }
                    }
                    .shadow(color:Color(white: 0.9),radius: 25)
                
                    Spacer()
                    AppSelectionBox(icon: "bolt",width: gr.size.width * 0.7)
                        .destination(destination: BoltHome().environmentObject(boltVM))
                    
                    Spacer()
                    
                    AppSelectionBox(icon: "vult",width: gr.size.width * 0.7)
                        .destination(destination: VultHome().environmentObject(vultVM))
                    
                    Spacer()
                                       
                    Text("v 1.0 (21) ")
                }
                .frame(maxWidth: .infinity)
                .padding(gr.size.width/15)
                .sheet(isPresented: $homeVM.pushAllocationDetails) { AllocationDetailsView(allocation: vultVM.allocation) }
                .sheet(isPresented: $homeVM.pushWalletDetails) { WalletDetailsView() }
                .sheet(isPresented: $homeVM.pushNetworkDetails) { NetworkDetails() }
                .onAppear { vultVM.getAllocation() }
            }
            .navigationTitle("ZusExample")
        }
    }
    
    @ViewBuilder func AppSelectionBox(icon: String,width:CGFloat) -> some View {
        Image(icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(width/10)
            .frame(maxWidth: .infinity)
            .background(Color.tertiarySystemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16)).shadow(color:Color(white: 0.9),radius: 25)
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
            }
            if presentWalletDetails {
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
                self.presentWalletDetails.toggle()
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
        let previewDefaults: UserDefaults = {
            let defaults = UserDefaults.standard
            let wallet = Wallet.init(client_id: "8378938937893893639", client_key: "397397639837", keys: [], mnemonics: "", version: "")
            let data = try? JSONEncoder().encode(wallet)
            defaults.set(data, forKey: Utils.UserDefaultsKey.wallet.rawValue)
            defaults.set("", forKey: Utils.UserDefaultsKey.allocationID.rawValue)
            return defaults
        }()
        
        HomeView()
            .defaultAppStorage(previewDefaults)
    }
}
