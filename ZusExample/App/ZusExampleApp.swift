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
    @StateObject var zcncoreVM: ZcncoreManager = ZcncoreManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if wallet.isEmpty {
                    CreateWalletView(zcncoreVM: zcncoreVM)
                } else {
                    AppSelectionView()
                }
            }
            .onAppear(perform: zcncoreVM.initialize)
        }
    }
}
