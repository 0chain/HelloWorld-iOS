//
//  AppSelectionView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI
import ZCNSwift

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
                            .sheet(destination: WalletDetailsView())
                        WalletActionBlock(icon: "allocation", title: "Allocation Details")
                            .sheet(destination: AllocationDetailsView(allocation: vultVM.allocation))
                        WalletActionBlock(icon: "network", title: "Network Details")
                            .sheet(destination: NetworkDetails())
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
            ZCNUserDefaults.wallet = wallet
            ZCNUserDefaults.allocationID = ""
            return defaults
        }()
        
        HomeView()
            .defaultAppStorage(previewDefaults)
    }
}
