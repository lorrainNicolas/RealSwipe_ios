//
//  CircleButtonView.swift
//  RealSwipe
//
//  Created by Utilisateur on 14/06/2025.
//

import SwiftUI

struct CircleButtonView: View {
  let size: CGFloat
  let image: Image
  
  init(size: CGFloat = 20, image: Image) {
    self.size = size
    self.image = image
  }
  var body: some View {
    image
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
        .frame(width: size, height: size)
        .foregroundColor(Color.white)
        .padding(15)
        .background(LinearGradients.selectedTool.clipShape(Circle()))
  }
}
