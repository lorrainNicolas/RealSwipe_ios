//
//  SectionView.swift
//  RealSwipe
//
//  Created by Utilisateur on 14/06/2025.
//

import SwiftUI

struct SectionView<Content: View>: View {
 
  private let title: String
  private let content: Content
  
  init(title: String,
       @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }
  
  var body: some View {
    VStack {
      Text(title)
        .font(.custom("Poppins Bold", size: 18))
        .frame(maxWidth: .infinity, alignment: .leading)
      content
        .padding()
        .background(.white)
        .cornerRadius(12)
    }
  }
}
