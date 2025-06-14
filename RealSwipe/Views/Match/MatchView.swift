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
      }.padding(.bottom, 100)
    }
  }
}

