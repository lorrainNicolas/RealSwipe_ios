//
//  CircleButtonView.swift
//  RealSwipe
//
//  Created by Utilisateur on 14/06/2025.
//

import SwiftUI

struct CircleButtonView: View {
  let image: Image
  var body: some View {
    image
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
        .frame(width: 30, height: 30)
        .foregroundColor(Color.white)
        .padding(15)
        .background(LinearGradients.selectedTool.clipShape(Circle()))
  }
}
