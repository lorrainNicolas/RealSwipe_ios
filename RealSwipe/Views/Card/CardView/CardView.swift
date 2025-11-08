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
      GeometryReader { geo in
        ScrollView {
          VStack() {
            CardImageView(size: .init(width: geo.size.width, height: geo.size.height * 3 / 4),
                          image: viewModel.image,
                          text: viewModel.name)
            .addBorder(.clear, width: 0, cornerRadius: 14)
            
            ZStack {
              VStack(alignment: .leading, spacing:  15) {
                
                CardSectionView(title: "Ma Localisation:") {
                  HStack {
                    Image(systemName: "location")
                    Text("Paris")
                      .frame(maxWidth: .infinity, alignment: .leading)
                  }
                }
                
                CardSectionView(title: "À propose de moi:") {
                  LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 16) {
                    CardLabelView(image: Image(systemName: "music.microphone.circle"), text: "Stand-up")
                    CardLabelView(image: Image(systemName: "bicycle"), text: "Velo")
                    CardLabelView(image: Image(systemName: "carrot"), text: "Nutrition")
                  }
                }
  
                CardSectionView(title: "Description:") {
                  Text("Hello, voici une description fun")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(spacing: 8) {
                  Text("Dis-nous si ce profil te plaît 👀:")
                    .font(.custom("Poppins Bold", size: 18))
                    .frame(maxWidth: .infinity, alignment: .center)
                  
                  HStack() {
                    CircleButtonView(image: Image(systemName: "cross")).rotationEffect(.degrees(45)).onTapGesture {
                      cardViewActionHandler.action.send((.dislike))
                    }
                    
                    Rectangle().fill(.clear).frame(width: 50)
                    
                    CircleButtonView(image: Image(systemName: "heart")).onTapGesture {
                      cardViewActionHandler.action.send((.like))
                    }
                  }.padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                  
                }.onScrollVisibilityChange(threshold: 0.1) { value in
                  showLikeOverlay = !value
                }
              }.padding(.top, 10)
            }.padding()
          }.addBorder(.clear, width: 0, cornerRadius: 24)
        }.scrollIndicators(.hidden)
        
      }.background(.regularMaterial)

      ZStack {
        if showLikeOverlay {
          CircleButtonView(size: 25, image: Image(systemName: "heart")).onTapGesture {
            cardViewActionHandler.action.send((.like))
          }
          .padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
      }.animation(.linear, value: showLikeOverlay)
    }
    .overlay {
      CardOverlayView()
    }
    .disabled(cardViewIsDragging)
    .addBorder(.clear, width: 0, cornerRadius: 24)
    .task {
      await viewModel.task()
    }
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
