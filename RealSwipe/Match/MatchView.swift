//
//  MatchView.swift
//  RealSwipe
//
//  Created by Utilisateur on 26/02/2023.
//

import Foundation
import SwiftUI

struct MatchView: View {
  @StateObject var viewModel: MatchViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Real")
        .font(.custom("Poppins Bold", size: 34))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
      
      ZStack(alignment: .bottom) {
        
        CardContainerView(cards: $viewModel.cards) {
          CardView(viewModel: $0)
            .ignoresSafeArea()
        }.padding(.top, 10)
          .padding(.bottom, 10)
          .padding(.horizontal, 6)
        
//        CircleButtonView(image: Image(systemName: "camera.fill"))
//          .padding(.trailing, 20)
//          .frame(maxWidth: .infinity, alignment: .trailing)
      }.padding(.bottom, 100)
    }
  }
}

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
