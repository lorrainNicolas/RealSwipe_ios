//
//  CardView.swift
//  RealSwipe
//
//  Created by Utilisateur on 05/02/2023.
//

import SwiftUI

struct CardView: View {
  
  @ObservedObject var viewModel: CardViewModel
  @Environment(\.cardViewIsDraggingHorizontally) var cardViewIsDragging
  @EnvironmentObject var cardViewActionHandler: CardViewActionHandler
  @State var showLikeOverlay: Bool = false
  
  init(viewModel: CardViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      ProfileView(viewModel: viewModel.profileViewModel) {
        VStack(spacing: 8) {
          Text("Dis-nous si ce profil te plaît 👀:")
            .font(.custom("Poppins Bold", size: 18))
            .frame(maxWidth: .infinity, alignment: .center)
          
          HStack() {
            CircleButtonView(image: Image(systemName: "cross")) {
              cardViewActionHandler.action.send((.dislike))
            }.rotationEffect(.degrees(45))
            
            Rectangle().fill(.clear).frame(width: 50)
            
            CircleButtonView(image: Image(systemName: "heart")) {
              cardViewActionHandler.action.send((.like))
            }
          }.padding()
            .frame(maxWidth: .infinity, alignment: .center)
          
        }.onScrollVisibilityChange(threshold: 0.1) { value in
          showLikeOverlay = !value
        }
      }

      ZStack {
        if showLikeOverlay {
          CircleButtonView(size: 25, image: Image(systemName: "heart")) {
            cardViewActionHandler.action.send((.like))
          }
          .padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
      }.animation(.linear, value: showLikeOverlay)
    }
    
    .overlay {
      CardOverlayView()
    }
    .addBorder(.clear, width: 0, cornerRadius: 24)
    .disabled(cardViewIsDragging)
  }
}

struct CardOverlayView: View {
  @Environment(\.cardViewPercentDragging) var cardViewPercentDragging
  var body: some View {
    ZStack {
      if cardViewPercentDragging < -0.10 {
        Color.red.opacity(0.5).opacity(min((abs(cardViewPercentDragging) - 0.10) * 2, 0.8))
      } else if cardViewPercentDragging > 0.10 {
        Color.green.opacity(0.5).opacity(min((abs(cardViewPercentDragging) - 0.10) * 2, 0.8))
      } else {
        Color .clear
      }
    } .allowsHitTesting(false)
  }
}
