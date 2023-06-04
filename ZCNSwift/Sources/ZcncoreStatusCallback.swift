//
//  ZcncoreStatusCallback.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 04/06/23.
//

import Foundation
import Zcncore

public class ZcncoreStatusCallback:NSObject, ZcncoreWalletCallbackProtocol {
  var onWalletCreate: ((Wallet) -> Void)?
  var onWalletFail: ((String) -> Void)?
  
  internal init(onWalletCreate: ((Wallet) -> Void)? = nil, onWalletFail: ((String) -> Void)? = nil) {
    self.onWalletCreate = onWalletCreate
    self.onWalletFail = onWalletFail
  }
  
    public func onWalletCreateComplete(_ status: Int, wallet: String?, err: String?) {
    print("📒 \(wallet ?? "")")
    DispatchQueue.main.async {
      guard status == 0,
            err == "",
            let walletJson = wallet,
            let w = try? JSONDecoder().decode(Wallet.self, from: Data(walletJson.utf8)) else {
        self.onWalletFail?(err ?? "Something went wrong :(")
        return
      }
      self.onWalletCreate?(w)
    }
  }
}
