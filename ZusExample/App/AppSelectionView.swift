//
//  AppSelectionView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct AppSelectionView: View {
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .center) {
                Spacer()
                AppSelectionBox(icon: "bolt",width: gr.size.width * 0.7, action: {})
                Spacer()
                AppSelectionBox(icon: "vult",width: gr.size.width * 0.7, action: {})
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct AppSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppSelectionView()
    }
}
