//
//  ZCNProgressStyle.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import Foundation
import SwiftUI

struct ZCNProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 25.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            GeometryReader { gr in
                RoundedRectangle(cornerRadius: gr.size.height/2)
                    .fill(Color.teal.opacity(0.3))
                    .frame(width: gr.size.width, alignment: .leading)
                RoundedRectangle(cornerRadius: gr.size.height/2)
                    .fill(Color.teal)
                    .frame(width: gr.size.width * fractionCompleted, alignment: .leading)
            }
        }
    }
}
