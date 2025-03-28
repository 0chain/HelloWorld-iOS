//
//  WalletActionStack.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import SwiftUI

struct WalletActionStack: View {
    @EnvironmentObject var boltVM: BoltViewModel
    @Environment(\.colorScheme) var colorScheme
    var width: CGFloat
    
    var body: some View {
        HStack(spacing:0) {
            ForEach(WalletActionType.allCases,id:\.self) { action in
                WalletActionButton(width: width, action: boltVM.walletAction, button: action)

            }
        }
        .frame(height:width/4)
        .background(Color.tertiarySystemBackground)
        .cornerRadius(12)
        .shadow(color: .init(white: colorScheme == .dark ? 0.05 : 0.75), radius: 75, x: 0, y: 0)
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
                .aspectRatio(1, contentMode: .fit)
                .frame(width: width/13)
            Text(button.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(uiColor: UIColor.label))
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
        case .send: return "send"
        case .receive: return "receive"
        case .faucet: return "faucet"
        }
    }
}

struct WalletActionStack_Previews: PreviewProvider {
    static var previews: some View {
        WalletActionStack(width: 345)
            .padding(50)
            .background()
            .environmentObject(BoltViewModel())
            .previewLayout(.sizeThatFits)
    }
}
