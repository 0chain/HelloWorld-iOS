//
//  SendForm.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 10/06/23.
//

import SwiftUI

struct SendForm: View {
    var sendZCN: (String, String) -> ()
    @State private var clientID: String = ""
    @State private var amount: String = ""
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section {
                TextField("client ID", text: $clientID)
                TextField("amount", text: $amount)
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
        self.sendZCN(clientID,amount)
    }
}

struct SendForm_Previews: PreviewProvider {
    static var previews: some View {
        SendForm(sendZCN: { _,_  in })
    }
}
