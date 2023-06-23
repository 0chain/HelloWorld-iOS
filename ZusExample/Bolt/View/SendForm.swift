//
//  SendForm.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 10/06/23.
//

import SwiftUI

struct SendForm: View {
    @EnvironmentObject var boltVM: BoltViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section {
                TextField("client ID", text: $boltVM.clientID)
                TextField("amount", text: $boltVM.amount)
                    .keyboardType(.decimalPad)
            }
            Section {
                Button("Send",action:send)
            }
        }
        .navigationTitle(Text("Send ZCN"))
    }
    
    func send() {
        dismiss.callAsFunction()
        boltVM.sendZCN()
    }
}

struct SendForm_Previews: PreviewProvider {
    static var previews: some View {
        SendForm()
            .environmentObject(BoltViewModel())
    }
}
