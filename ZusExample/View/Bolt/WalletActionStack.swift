//
//  WalletActionStack.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import SwiftUI

struct WalletActionStack: View {
    @EnvironmentObject var boltVM: BoltViewModel
    var width: CGFloat
    
    var body: some View {
        HStack(spacing:0) {
            ForEach(WalletActionType.allCases,id:\.self) { action in
                WalletActionButton(width: width, action: boltVM.walletAction, button: action)

            }
        }
        .frame(height:width/4)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray, radius: 75, x: 0, y: 0)
        .padding(.bottom,10)
    }
}

struct WalletActionButton: View {
    var width: CGFloat
    var action: (WalletActionType)->()
    var button: WalletActionType
    
    init(width: CGFloat, action: @escaping (WalletActionType) -> (), button: WalletActionType) {
        self.width = width
        self.action = action
        self.button = button
    }
    
    var body: some View {
        VStack(spacing:15) {
            Image(button.image)
                .resizable()
                .frame(width: width/13)
                .rotationEffect(.degrees(button == .receive ? 180 : 0))
            Text(button.title)
                .font(.system(size: 13, weight: .semibold))
        }
        .frame(width: width/3)
        .onTapGesture{ self.action(button) }
    }
}

enum WalletActionType: CaseIterable {
    case send
    case receive
    case faucet
    
    var title: String {
        switch self {
        case .send: return "Send"
        case .receive: return "Receive"
        case .faucet: return "Faucet"
        }
    }
    
    var image: String {
        switch self {
        case .send: return "up_arrow_icon"
        case .receive: return "up_arrow_icon"
        case .faucet: return ""
        }
    }
}

struct WalletActionStack_Previews: PreviewProvider {
    static var previews: some View {
        WalletActionStack(width: 345)
            .environmentObject(BoltViewModel())
            .previewLayout(.sizeThatFits)
    }
}
