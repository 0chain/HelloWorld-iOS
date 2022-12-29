//
//  AppSelectionView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct AppSelectionView: View {
    var body: some View {
        NavigationView {
            GeometryReader { gr in
                VStack(alignment: .center) {
                    Spacer()
                    AppSelectionBox(icon: "bolt",width: gr.size.width * 0.7)
                        .destination(destination: BoltHome())
                    
                    Spacer()
                    AppSelectionBox(icon: "vult",width: gr.size.width * 0.7)
                        .destination(destination: BoltHome())
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct AppSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppSelectionView()
    }
}
