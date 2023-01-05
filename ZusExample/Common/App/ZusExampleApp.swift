//
//  ZusExampleApp.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

@main
struct ZusExampleApp: App {
    @AppStorage(Utils.UserDefaultsKey.walletJSON.rawValue) var wallet: String = ""
    @AppStorage(Utils.UserDefaultsKey.allocationID.rawValue) var allocation: String = ""

    @StateObject var zcncoreVM: ZcncoreManager = ZcncoreManager.shared
    init() {
        zcncoreVM.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if wallet.isEmpty || allocation.isEmpty {
                    CreateWalletView(zcncoreVM: zcncoreVM)
                } else {
                    AppSelectionView()
                }
            }
            .environmentObject(zcncoreVM)
        }
    }
}
