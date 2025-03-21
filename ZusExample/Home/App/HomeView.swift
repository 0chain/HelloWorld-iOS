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
                VStack(alignment: .center,spacing: 50) {
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
                    .aspectRatio(2.5, contentMode: .fit)
                    .shadow(color: Color(white: 0.9),radius: colorScheme == .light ? 25 : 0)
                

                    HStack {
                        AppSelectionBox(icon: "bolt",width: gr.size.width * 0.7)
                            .destination(destination: BoltHome().environmentObject(boltVM))
                        
                        AppSelectionBox(icon: "vult",width: gr.size.width * 0.7)
                            .destination(destination: VultHome().environmentObject(vultVM))
                    }
                    
                    Spacer()
                    
                    Text(Bundle.main.applicationVersion)
                }
                .frame(maxWidth: .infinity)
                .padding(gr.size.width/15)
                .sheet(isPresented: $homeVM.pushAllocationDetails) { AllocationDetailsView(allocation: vultVM.allocation) }
                .sheet(isPresented: $homeVM.pushWalletDetails) { WalletDetailsView() }
                .sheet(isPresented: $homeVM.pushNetworkDetails) { NetworkDetails() }
                .onAppear(perform: vultVM.getAllocation)
            }
            .background(Color.background)
            .navigationTitle("Hello World!")
        }
    }
    
    @ViewBuilder func AppSelectionBox(icon: String,width:CGFloat) -> some View {
        Image(icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(width/10)
            .frame(maxWidth: .infinity)
            .background(Color.background.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16)).shadow(color:Color(white: 0.9),radius: colorScheme == .light ? 25 : 0)
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
