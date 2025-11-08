//
//  CardSectionView.swift
//  RealSwipe
//
//  Created by Utilisateur on 03/11/2025.
//

import SwiftUI

struct CardSectionView<Content: View>: View {
  let title: String
  @ViewBuilder var content: Content
  var body: some View {
    VStack(alignment: .leading, spacing:  15) {
      
      VStack(spacing:  15) {
        Text(title)
          .font(.custom("Poppins Bold", size: 18))
          .frame(maxWidth: .infinity, alignment: .leading)
        
        content.padding()
      }
      .padding()
      .background(Color.init(hex: "1c1c1e"))
      .cornerRadius(12)
      .shadow(radius: 12)
    }
  }
}
