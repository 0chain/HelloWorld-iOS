//
//  ZusExampleApp.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI
import ZCNSwift

@main
struct ZusExampleApp: App {
    @AppStorage(ZCNUserDefaultsKey.walletJSON.rawValue) var wallet: String = ""
    @AppStorage(ZCNUserDefaultsKey.allocationID.rawValue) var allocation: String = ""
    @StateObject var zcncoreVM: ZusExampleViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if wallet.isEmpty || allocation.isEmpty {
                    CreateWalletView(zcncoreVM: zcncoreVM)
                } else {
                    HomeView()
                }
            }
            .environmentObject(zcncoreVM)
        }
    }
}
