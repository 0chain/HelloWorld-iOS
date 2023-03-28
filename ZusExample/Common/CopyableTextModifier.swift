//
//  CopyableTextModifier.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/03/23.
//

import Foundation
import SwiftUI

extension View {
    func copyableText(_ textToCopy: String) -> some View {
        self.modifier(CopyableTextModifier(textToCopy: textToCopy))
    }
}

struct CopyableTextModifier: ViewModifier {
    let textToCopy: String

    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = textToCopy
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
    }
}
