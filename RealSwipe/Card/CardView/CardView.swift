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
  @Environment(\.cardViewPercentDragging) var cardViewPercentDragging
  @EnvironmentObject var cardViewActionHandler: CardViewActionHandler
  
  init(viewModel: CardViewModel) {
    self.viewModel = viewModel
    
  }
  
  var body: some View {
    ZStack(alignment: .center) {
      Colors.contentBackground
      GeometryReader { geo in
        ScrollView {
          ImageView(size: .init(width: geo.size.width, height: geo.size.height - 100))
        }.disabled(cardViewIsDragging)
      }
    }.overlay {
      ZStack {
        overlayColor()
          .allowsHitTesting(false)
      }.opacity(overlayOpacity())
    }.addBorder(.clear, width: 0, cornerRadius: 24)
//      GeometryReader { geo in
//        ScrollView {
//          ImageView()
//            .frame(width: geo.size.width, height: geo.size.height - 40)
        
        //          ZStack {
//            Color.init(hex: "1c1c1e")
//            VStack {
//              Text("Nicolas").bold()
//              Text("Description").bold()
//              Text("Hello comment tu vas voicu une desctiion Fun")
//              
//              
//              VStack(spacing: 0) {
//                Text("Alors ton envie:")
//                  .bold()
//                
//                HStack() {
//                  CircleButtonView(image: Image(systemName: "hand.thumbsup.fill")).rotationEffect(.degrees(180)).onTapGesture {
//                    cardViewActionHandler.action.send((.dislike))
//                  }
//                  
//                  Rectangle().fill(.clear).frame(width: 100)
//                  
//                  CircleButtonView(image: Image(systemName: "hand.thumbsup.fill")).onTapGesture {
//                    cardViewActionHandler.action.send((.like))
//                  }
//                }.padding()
//              }
//              
//            }
//          }//.addBorder(.clear, width: 0, cornerRadius: 24)
//            .offset(y: -100)
//        }.scrollIndicators(.hidden)
//          .disabled(cardViewIsDragging)
//      }
//    }.background(.regularMaterial)
//    .overlay {
//      ZStack {
//        overlayColor()
//          .allowsHitTesting(false)
//      }.opacity(overlayOpacity())
//    }
   // .addBorder(.clear, width: 0, cornerRadius: 24).clipped(antialiased: true)
  }
  
  func overlayColor() -> Color {
    if cardViewPercentDragging < -0.10 {
      return .red
    } else if cardViewPercentDragging > 0.10 {
      return .green
    } else {
      return .clear
    }
  }
  
  func overlayOpacity() -> CGFloat {
    if cardViewPercentDragging < -0.10 {
      return min((abs(cardViewPercentDragging) - 0.10) * 2, 0.8)
    } else if cardViewPercentDragging > 0.10 {
      return min((cardViewPercentDragging - 0.10) * 2, 0.8)
    } else {
      return 0
    }
  }
  
  struct ImageView: View {
    let size: CGSize
    
    var body: some View {
      ZStack(alignment: .bottom) {
        
        Image("imageTest", bundle: nil)
          .resizable()
          .aspectRatio(16/9, contentMode: .fill)
          .frame(width: size.width, height:size.height)
          .onTapGesture { print("click") }
        
        ZStack {

          LinearGradient(colors: [Color.clear,
                                  Color.black],
                         startPoint: .top,
                         endPoint: .bottom)
          
          Text("Nicolas")
            .font(.custom("Poppins Bold", size: 24))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
 
        }.frame(maxWidth: .infinity, alignment: .leading)
         .frame(height: 100)
      }
    }
  }
}

