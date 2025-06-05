//
//  ButtonView.swift
//  RealSwipe
//
//  Created by Utilisateur on 12/03/2023.
//

import SwiftUI

struct ButtonView: View {
  enum Constants {
    static let height: CGFloat = 60
  }
  
  let title: String
  let tapGestureHandler: () -> Void

  var body: some View {
    ZStack {
      Rectangle().frame(height:  Constants.height)
        .foregroundStyle(LinearGradients.selectedTool).frame(height: Constants.height)
        .addBorder(Color.black, width: 0.1, cornerRadius: Constants.height)
      Text(title)
        .lineLimit(1)
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .center)
    }.onTapGesture {
      tapGestureHandler()
    }
  }
}
