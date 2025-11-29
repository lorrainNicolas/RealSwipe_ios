//
//  ConversationView.swift
//  RealSwipe
//
//  Created by Utilisateur on 28/11/2025.
//

import SwiftUI

struct ConversationView: View {
  
  @ObservedObject var viewModel: ConversationViewModel
  
  var body: some View {
    ZStack {
      HStack {
        ZStack {
          
          Circle()
            .fill(.white)
          
          if let image = viewModel.profileImage {
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 50, height: 50)
              .clipShape(Circle())
          }
        }
        .frame(width: 50, height: 50)
        
        VStack(alignment: .leading) {
          Text(viewModel.name)
            .foregroundStyle(Colors.text)
            .lineLimit(1)
          
          Text(viewModel.message)
            .foregroundStyle(Colors.text)
            .lineLimit(1)
          
        }
      }
    }
  }
}
