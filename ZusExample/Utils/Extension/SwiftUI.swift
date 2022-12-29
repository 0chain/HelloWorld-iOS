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
    
    init(destination: Destination) {
        self.destination = destination
    }
    
    func body(content: Content) -> some View {
        NavigationLink(destination: destination) {
            content
        }
    }
}

extension View {
    @ViewBuilder func destination<Destination: View>(destination: Destination) -> some View {
       modifier(Navigation(destination: destination))
    }
}
