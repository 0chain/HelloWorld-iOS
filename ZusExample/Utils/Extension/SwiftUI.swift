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

struct SheetPopup<Destination: View>: ViewModifier {
    var destination: Destination
    @State var isPresented: Bool = false
    
    init(destination: Destination) {
        self.destination = destination
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented, content: { destination })
            .onTapGesture {
                self.isPresented = true
            }
    }
}

struct TapToggle: ViewModifier {
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                self.isPresented = true
            }
    }
}

struct ZCNToastModifier: ViewModifier {
    var type: ZCNToast.ZCNToastType = .success("Successfully recieved token")
    @Binding var presented: Bool
    @State var autoDismiss = true
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if presented {
                ZCNToast(type: type, presented: $presented, autoDismiss: autoDismiss)
            }
        }
    }
}

extension View {
    @ViewBuilder func destination<Destination: View>(destination: Destination) -> some View {
       modifier(Navigation(destination: destination))
    }
    
    @ViewBuilder func sheet<Destination: View>(destination: Destination) -> some View {
       modifier(SheetPopup(destination: destination))
    }
    
    @ViewBuilder func tapToggle(_ isPresented: Binding<Bool>) -> some View {
       modifier(TapToggle(isPresented: isPresented))
    }
    
    @ViewBuilder func toast(presented: Binding<Bool>,type: ZCNToast.ZCNToastType,autoDismiss: Bool = true) -> some View {
       modifier(ZCNToastModifier(type: type, presented: presented, autoDismiss: autoDismiss))
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
