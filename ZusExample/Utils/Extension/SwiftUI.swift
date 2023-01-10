//
//  SwiftUI.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import Foundation
import SwiftUI

struct Navigation<Destination: View>: ViewModifier {
    var destination: Destination
    
    /// initialize navigation
    /// - Parameter destination: destination of navigation view
    init(destination: Destination) {
        self.destination = destination
    }
    
    func body(content: Content) -> some View {
        NavigationLink(destination: destination) {
            content
        } //NavigationLink
    }
}

extension View {
    @ViewBuilder func destination<Destination: View>(destination: Destination) -> some View {
       modifier(Navigation(destination: destination))
    }
}

extension Color {
    static let background = Color("background")
    
    #if os(iOS)
    static let tertiarySystemBackground = Color(uiColor: UIKit.UIColor.tertiarySystemBackground)
    #else
    static let tertiarySystemBackground = Color(nsColor: AppKit.NSColor.tertiarySystemBackground)
    #endif
    
}
