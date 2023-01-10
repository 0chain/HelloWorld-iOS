//
//  ZCNToast.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 09/01/23.
//

import SwiftUI

struct ZCNToast: View {
    var type: ZCNToastType = .success("Successfully recieved token")
    @Binding var presented: Bool
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .center,spacing: 0) {
                HStack(alignment: .center,spacing: 20) {
                    
                    Image(systemName: type.image)
                        .resizable()
                        .foregroundColor(Color(uiColor: type.titleColor))
                        .aspectRatio(1,contentMode: .fit)
                        .frame(width: 40)
                    
                    Text(type.message)
                        .bold()
                        .foregroundColor(Color(uiColor: type.titleColor))
                }
            }
        }
        .aspectRatio(10, contentMode: .fit)
        .padding()
        .background(Color(type.backgroundColor))
        .cornerRadius(12)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.presented = false
            }
        }
    }
    
    enum ZCNToastType: Equatable {
        case success(String)
        case progress(String)
        case error(String)
        
        var message: String {
            switch self {
            case .success(let message), .progress(let message),.error(let message): return message
            }
        }
        
        var titleColor: UIColor {
          switch self {
          case .success: return #colorLiteral(red: 0.1918937266, green: 0.6557719707, blue: 0.2314968407, alpha: 1)
          case .progress: return #colorLiteral(red: 0.1098039216, green: 0.368627451, blue: 1, alpha: 1)
          case .error: return #colorLiteral(red: 0.2117647059, green: 0.007843137255, blue: 0.0431372549, alpha: 1)
          }
        }

        var backgroundColor: UIColor {
          switch self {
          case .success: return #colorLiteral(red: 0.7421699762, green: 0.9461635947, blue: 0.7746070623, alpha: 1)
          case .progress: return #colorLiteral(red: 0.8078431373, green: 0.8745098039, blue: 0.9764705882, alpha: 1)
          case .error: return #colorLiteral(red: 0.9137254902, green: 0.4745098039, blue: 0.5294117647, alpha: 1)
          }
        }
        
        var image: String {
          switch self {
          case .success: return "checkmark.seal.fill"
          case .progress: return "arrow.uturn.down.square.fill"
          case .error: return "exclamationmark.octagon.fill"
          }
        }
        
        var imageColor: Color {
          switch self {
          case .success: return .green
          case .progress: return .yellow
          case .error: return .red
          }
        }
    }
}

struct ZCNToast_Previews: PreviewProvider {
    static var previews: some View {
        ZCNToast(presented: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
