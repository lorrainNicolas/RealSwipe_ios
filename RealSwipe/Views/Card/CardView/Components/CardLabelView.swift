//
//  CardLabelView.swift
//  RealSwipe
//
//  Created by Utilisateur on 03/11/2025.
//

import SwiftUI

struct CardLabelView: View {
  let image: Image
  let text: String
  var body: some View {
    
    HStack {
      image
      Text(text)
    }.frame(height: 10)
     .padding(10)
     .background(.black.opacity(0.9))
     .cornerRadius(20)
  }
}
