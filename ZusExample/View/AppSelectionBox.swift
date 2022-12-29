//
//  AppSelectionBox.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct AppSelectionBox: View {
    private var icon: String
    private var width: CGFloat
    private var action: () -> (Void)
    
    internal init(icon: String, width: CGFloat, action: @escaping () -> (Void)) {
        self.icon = icon
        self.width = width
        self.action = action
    }
    
    var body: some View {
        Image(icon)
            .resizable()
            .aspectRatio(2, contentMode: .fit)
            .frame(width: width)
            .padding(width/10)
            .background(RoundedRectangle(cornerRadius: 16).fill(.background).shadow(radius: 5))
            .onTapGesture(perform: action)
    }
}

struct AppSelectionBox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppSelectionBox(icon: "bolt", width: 350,action: {})
                .padding(100)
            
            AppSelectionBox(icon: "vult", width: 350,action: {})
                .padding(100)
        }
        .previewLayout(.sizeThatFits)
    }
}
