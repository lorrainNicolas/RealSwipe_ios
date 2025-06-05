//
//  StepView.swift
//  RealSwipe
//
//  Created by Utilisateur on 19/05/2025.
//

import SwiftUI

struct StepView<Content: View>: View {
  private let content: Content
  private let title: String
  
  init(title: String,
       @ViewBuilder content: () -> Content) {
    self.content = content()
    self.title = title
  }
  
  var body: some View {
    ZStack(alignment: .center) {
      Colors
        .background
        .ignoresSafeArea()
      
      VStack {
        Text(title)
          .foregroundStyle(Colors.text)
          .font(.custom("Poppins Bold", size: 45))
          .padding(.horizontal, 20)
          .frame(maxWidth: .infinity, alignment: .leading)
          
        content.padding(.horizontal, 20)
      }.padding(.top, 32)
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
  }
}
