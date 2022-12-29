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
    
    internal init(icon: String, width: CGFloat) {
        self.icon = icon
        self.width = width
    }
    
    var body: some View {
        Image(icon)
            .resizable()
            .aspectRatio(2, contentMode: .fit)
            .frame(width: width)
            .padding(width/10)
            .background(RoundedRectangle(cornerRadius: 16).fill(.background).shadow(radius: 5))
    }
}

struct AppSelectionBox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppSelectionBox(icon: "bolt", width: 350)
            AppSelectionBox(icon: "vult", width: 350)
        }
        .padding(100)
        .previewLayout(.sizeThatFits)
    }
}
